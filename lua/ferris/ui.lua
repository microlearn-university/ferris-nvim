-- Floating window for exercise description + hints.

local M = {}

local state = { buf = nil, win = nil }

local function close_float()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_close(state.win, true)
  end
  if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
    vim.api.nvim_buf_delete(state.buf, { force = true })
  end
  state.buf = nil
  state.win = nil
end

function M.show(exercise, idx, total, hints_shown)
  close_float()

  local lines = {}

  -- Progress line
  table.insert(lines, string.format('  Exercise %d / %d', idx, total))
  table.insert(lines, '')

  -- Description (word-wrapped at ~46 chars)
  local desc = exercise.description or ''
  local words, line = vim.split(desc, ' '), ''
  for _, w in ipairs(words) do
    if #line + #w + 1 > 46 and line ~= '' then
      table.insert(lines, '  ' .. line)
      line = w
    else
      line = line == '' and w or (line .. ' ' .. w)
    end
  end
  if line ~= '' then table.insert(lines, '  ' .. line) end
  table.insert(lines, '')

  -- Hints
  if #exercise.hints > 0 then
    if hints_shown == 0 then
      table.insert(lines, string.format('  %d hint%s available  :FerrisHint',
        #exercise.hints, #exercise.hints == 1 and '' or 's'))
    else
      table.insert(lines, '  ─── Hints' .. string.rep('─', 35))
      for i = 1, hints_shown do
        local h = exercise.hints[i]
        if h then
          -- wrap hint
          local hw, hl = vim.split(h, ' '), ''
          for _, w in ipairs(hw) do
            if #hl + #w + 1 > 42 and hl ~= '' then
              table.insert(lines, '  ' .. i .. '  ' .. hl)
              hl = w
              i = ' '  -- indent continuation
            else
              hl = hl == '' and w or (hl .. ' ' .. w)
            end
          end
          if hl ~= '' then table.insert(lines, '  ' .. i .. '  ' .. hl) end
          table.insert(lines, '')
        end
      end
      local remaining = #exercise.hints - hints_shown
      if remaining > 0 then
        table.insert(lines, string.format('  %d more hint%s  :FerrisHint',
          remaining, remaining == 1 and '' or 's'))
      end
    end
    table.insert(lines, '')
  end

  -- Commands footer
  table.insert(lines, '  :FerrisCheck   :FerrisNext')
  table.insert(lines, '  :FerrisReset   :FerrisHint')

  -- Determine dimensions
  local width  = 50
  local height = math.min(#lines, vim.o.lines - 6)

  state.buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)
  vim.bo[state.buf].modifiable = false

  state.win = vim.api.nvim_open_win(state.buf, false, {
    relative   = 'editor',
    row        = 1,
    col        = vim.o.columns - width - 2,
    width      = width,
    height     = height,
    style      = 'minimal',
    border     = 'rounded',
    title      = ' 🦀 ferris ',
    title_pos  = 'center',
    zindex     = 50,
  })

  vim.wo[state.win].wrap     = true
  vim.wo[state.win].winhl    = 'Normal:FerrisFloat,FloatBorder:FerrisBorder,FloatTitle:FerrisTitle'
  vim.wo[state.win].foldenable = false
end

function M.close()
  close_float()
end

-- Echo a one-line result at the bottom.
function M.echo_result(ok, msg)
  if ok then
    vim.api.nvim_echo({ { ' ✓ ' .. msg .. ' — :FerrisNext to continue', 'FerrisSuccess' } }, true, {})
  else
    -- Show only the first line of the message so it fits
    local first = (msg or ''):match('^[^\n]+') or msg or ''
    vim.api.nvim_echo({ { ' ✗ ' .. first, 'FerrisError' } }, true, {})
  end
end

function M.echo_checking()
  vim.api.nvim_echo({ { ' ⟳ checking…', 'Comment' } }, false, {})
end

return M
