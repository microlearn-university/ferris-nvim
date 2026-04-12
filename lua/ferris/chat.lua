-- Chat with Ferris — two stacked floats (history + input) backed by Claude API.

local M = {}

local cfg = {
  model       = 'claude-haiku-4-5-20251001',
  max_tokens  = 1024,
  api_key_env = 'ANTHROPIC_API_KEY',
  api_key     = nil,
}

function M.setup(opts)
  cfg = vim.tbl_deep_extend('force', cfg, opts or {})
end

local state = {
  chat_buf  = nil,
  chat_win  = nil,
  inp_buf   = nil,
  inp_win   = nil,
  history   = {},
  thinking  = false,
}

-- ── Helpers ───────────────────────────────────────────────────────────────────

local function get_api_key()
  local key = cfg.api_key or os.getenv(cfg.api_key_env)
  return (key and key ~= '') and key or nil
end

local function chat_append(lines)
  local buf, win = state.chat_buf, state.chat_win
  if not (buf and vim.api.nvim_buf_is_valid(buf)) then return end
  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_lines(buf, -1, -1, false, lines)
  vim.bo[buf].modifiable = false
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_win_set_cursor(win, { vim.api.nvim_buf_line_count(buf), 0 })
  end
end

local function chat_remove_tail(n)
  local buf = state.chat_buf
  if not (buf and vim.api.nvim_buf_is_valid(buf)) then return end
  vim.bo[buf].modifiable = true
  local count = vim.api.nvim_buf_line_count(buf)
  vim.api.nvim_buf_set_lines(buf, math.max(0, count - n), -1, false, {})
  vim.bo[buf].modifiable = false
end

local function wrap(text, width)
  local out = {}
  for _, para in ipairs(vim.split(text, '\n', { plain = true })) do
    if para == '' then
      table.insert(out, '')
    else
      local line = ''
      for _, word in ipairs(vim.split(para, ' ', { plain = true })) do
        if line == '' then
          line = word
        elseif #line + 1 + #word > width then
          table.insert(out, line)
          line = word
        else
          line = line .. ' ' .. word
        end
      end
      if line ~= '' then table.insert(out, line) end
    end
  end
  return out
end

-- ── Close ─────────────────────────────────────────────────────────────────────

local function close()
  for _, w in ipairs({ state.chat_win, state.inp_win }) do
    if w and vim.api.nvim_win_is_valid(w) then
      pcall(vim.api.nvim_win_close, w, true)
    end
  end
  for _, b in ipairs({ state.chat_buf, state.inp_buf }) do
    if b and vim.api.nvim_buf_is_valid(b) then
      pcall(vim.api.nvim_buf_delete, b, { force = true })
    end
  end
  state.chat_buf = nil; state.chat_win = nil
  state.inp_buf  = nil; state.inp_win  = nil
  state.history  = {}
  state.thinking = false
end

-- ── Send ──────────────────────────────────────────────────────────────────────

local function send(exercise, code)
  if state.thinking then return end
  if not (state.inp_buf and vim.api.nvim_buf_is_valid(state.inp_buf)) then return end

  local lines = vim.api.nvim_buf_get_lines(state.inp_buf, 0, -1, false)
  local msg   = vim.trim(table.concat(lines, '\n'))
  if msg == '' then return end

  -- Clear input and go back to insert
  vim.api.nvim_buf_set_lines(state.inp_buf, 0, -1, false, { '' })
  if state.inp_win and vim.api.nvim_win_is_valid(state.inp_win) then
    vim.api.nvim_set_current_win(state.inp_win)
  end

  -- Show user message
  local user_out = { '' }
  table.insert(user_out, 'You:')
  for _, l in ipairs(wrap(msg, 54)) do
    table.insert(user_out, '  ' .. l)
  end
  chat_append(user_out)

  -- Thinking placeholder (2 lines we'll remove on response)
  chat_append({ '', '🦀 Ferris: …' })
  local THINKING_LINES = 2

  table.insert(state.history, { role = 'user', content = msg })
  state.thinking = true

  -- Check API key
  local key = get_api_key()
  if not key then
    chat_remove_tail(THINKING_LINES)
    chat_append({
      '',
      '🦀 Ferris: No API key found.',
      '  Set ANTHROPIC_API_KEY or configure',
      '  chat = { api_key = "..." } in setup().',
      '',
    })
    state.thinking = false
    return
  end

  -- Build system prompt
  local sys = {
    'You are Ferris, the friendly Rust crab mascot and Rust programming tutor.',
    'Help the student with their current Neovim ferris.nvim exercise.',
    'Be concise and clear — they are reading in a terminal chat window.',
    '',
    'Exercise: ' .. (exercise.title or ''),
    'Description: ' .. (exercise.description or ''),
  }
  if code ~= '' then
    table.insert(sys, '')
    table.insert(sys, "Student's current code:")
    table.insert(sys, '```rust')
    table.insert(sys, code)
    table.insert(sys, '```')
  end

  local payload = vim.json.encode({
    model      = cfg.model,
    max_tokens = cfg.max_tokens,
    system     = table.concat(sys, '\n'),
    messages   = state.history,
  })

  local chunks = {}
  vim.fn.jobstart({
    'curl', '-s', 'https://api.anthropic.com/v1/messages',
    '-H', 'x-api-key: ' .. key,
    '-H', 'anthropic-version: 2023-06-01',
    '-H', 'content-type: application/json',
    '-d', payload,
  }, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      for _, chunk in ipairs(data or {}) do
        if chunk ~= '' then table.insert(chunks, chunk) end
      end
    end,
    on_exit = function()
      vim.schedule(function()
        state.thinking = false
        chat_remove_tail(THINKING_LINES)

        local ok, resp = pcall(vim.json.decode, table.concat(chunks, ''))
        if not ok or type(resp) ~= 'table' then
          chat_append({ '', '🦀 Ferris: (error — could not parse API response)', '' })
          return
        end
        if resp.error then
          chat_append({ '', '🦀 Ferris: API error — ' .. (resp.error.message or 'unknown'), '' })
          return
        end

        local text = resp.content and resp.content[1] and resp.content[1].text or ''
        table.insert(state.history, { role = 'assistant', content = text })

        local reply = { '', '🦀 Ferris:' }
        for _, l in ipairs(wrap(text, 54)) do
          table.insert(reply, '  ' .. l)
        end
        table.insert(reply, '')
        chat_append(reply)

        if state.inp_win and vim.api.nvim_win_is_valid(state.inp_win) then
          vim.api.nvim_set_current_win(state.inp_win)
          vim.cmd('startinsert')
        end
      end)
    end,
  })
end

-- ── Open ──────────────────────────────────────────────────────────────────────

function M.open(exercise, filepath)
  -- Already open — just focus it
  if state.inp_win and vim.api.nvim_win_is_valid(state.inp_win) then
    vim.api.nvim_set_current_win(state.inp_win)
    vim.cmd('startinsert')
    return
  end

  -- Read working file for context
  local code = ''
  if filepath and filepath ~= '' and vim.fn.filereadable(filepath) == 1 then
    code = table.concat(vim.fn.readfile(filepath), '\n')
  end

  -- Layout: two stacked floats, centered
  local width  = math.min(64, vim.o.columns - 4)
  local inp_h  = 3
  local chat_h = math.max(8, vim.o.lines - inp_h - 10)
  local col    = math.floor((vim.o.columns - width) / 2)
  local row    = math.max(1, math.floor((vim.o.lines - chat_h - inp_h - 6) / 2))
  local inp_row = math.min(row + chat_h + 2, vim.o.lines - inp_h - 3)

  -- Chat history buffer (read-only)
  state.chat_buf = vim.api.nvim_create_buf(false, true)
  vim.bo[state.chat_buf].modifiable = true
  vim.api.nvim_buf_set_lines(state.chat_buf, 0, -1, false, {
    '  Ask Ferris anything about this exercise.',
    '  <CR> to send  ·  q to close',
    '',
  })
  vim.bo[state.chat_buf].modifiable = false

  state.chat_win = vim.api.nvim_open_win(state.chat_buf, false, {
    relative  = 'editor',
    row       = row,
    col       = col,
    width     = width,
    height    = chat_h,
    style     = 'minimal',
    border    = 'rounded',
    title     = ' 🦀 chat with ferris ',
    title_pos = 'center',
    zindex    = 60,
  })
  vim.wo[state.chat_win].wrap       = true
  vim.wo[state.chat_win].winhl      = 'Normal:FerrisFloat,FloatBorder:FerrisBorder,FloatTitle:FerrisTitle'
  vim.wo[state.chat_win].foldenable = false
  vim.wo[state.chat_win].cursorline = false

  -- Input buffer
  state.inp_buf = vim.api.nvim_create_buf(false, true)
  vim.bo[state.inp_buf].buftype = 'nofile'

  state.inp_win = vim.api.nvim_open_win(state.inp_buf, true, {
    relative  = 'editor',
    row       = inp_row,
    col       = col,
    width     = width,
    height    = inp_h,
    style     = 'minimal',
    border    = 'rounded',
    title     = ' message ',
    title_pos = 'center',
    zindex    = 60,
  })
  vim.wo[state.inp_win].wrap  = true
  vim.wo[state.inp_win].winhl = 'Normal:FerrisFloat,FloatBorder:FerrisBorder,FloatTitle:FerrisTitle'

  -- Keymaps
  local function map(buf, modes, lhs, fn)
    vim.keymap.set(modes, lhs, fn, { buffer = buf, noremap = true, silent = true })
  end

  map(state.inp_buf,  { 'n', 'i' }, '<CR>',  function() send(exercise, code) end)
  map(state.inp_buf,  'n',          'q',      close)
  map(state.inp_buf,  'n',          '<Esc>',  close)
  map(state.chat_buf, 'n',          'q',      close)
  map(state.chat_buf, 'n',          '<Esc>',  close)

  vim.cmd('startinsert')
end

return M
