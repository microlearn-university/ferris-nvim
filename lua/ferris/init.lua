local M = {}

local exercises = require('ferris.exercises')
local checker   = require('ferris.checker')
local ui        = require('ferris.ui')
local progress  = require('ferris.progress')
local chat      = require('ferris.chat')

local state = {
  idx         = 1,
  hints_shown = 0,
  checking    = false,
  augroup     = nil,
  buf         = nil,
  plugin_dir  = nil,
}

-- ── Helpers ───────────────────────────────────────────────────────────────────

local function plugin_dir()
  if state.plugin_dir then return state.plugin_dir end
  local info = debug.getinfo(1, 'S')
  -- source is "@/path/to/lua/ferris/init.lua" — go up three levels
  state.plugin_dir = vim.fn.fnamemodify(info.source:sub(2), ':h:h:h')
  return state.plugin_dir
end

local function source_path(ex)
  return plugin_dir() .. '/exercises/' .. ex.file
end

local function setup_highlights()
  -- Only set if not already defined
  local groups = {
    FerrisFloat   = { bg = '#1e1e2e', fg = '#cdd6f4' },
    FerrisBorder  = { fg = '#fab387' },  -- peach / rust-orange
    FerrisTitle   = { fg = '#fab387', bold = true },
    FerrisSuccess = { fg = '#a6e3a1', bold = true },
    FerrisError   = { fg = '#f38ba8', bold = true },
  }
  for name, opts in pairs(groups) do
    if vim.fn.hlexists(name) == 0 then
      vim.api.nvim_set_hl(0, name, opts)
    end
  end
end

local function ns()
  return vim.api.nvim_create_namespace('ferris')
end

-- ── Public API ────────────────────────────────────────────────────────────────

function M.setup(opts)
  opts = opts or {}
  setup_highlights()
  if opts.chat then chat.setup(opts.chat) end
  local prog = progress.load()
  state.idx = math.max(1, math.min(prog.current or 1, #exercises))
end

function M.open(idx)
  setup_highlights()
  idx = math.max(1, math.min(idx or state.idx, #exercises))
  state.idx         = idx
  state.hints_shown = 0

  local ex      = exercises[idx]
  local src     = source_path(ex)
  local working = progress.working_file(ex.id, src)

  -- Save position
  local prog = progress.load()
  prog.current = idx
  progress.save(prog)

  -- Open the working copy
  vim.cmd('edit ' .. vim.fn.fnameescape(working))
  state.buf = vim.api.nvim_get_current_buf()

  -- Auto-check on save
  if state.augroup then
    pcall(vim.api.nvim_del_augroup_by_id, state.augroup)
  end
  state.augroup = vim.api.nvim_create_augroup('FerrisAutoCheck', { clear = true })
  vim.api.nvim_create_autocmd('BufWritePost', {
    group    = state.augroup,
    buffer   = state.buf,
    callback = function() M.check() end,
  })

  -- Show description float
  ui.show(ex, idx, #exercises, state.hints_shown)
end

function M.check()
  if state.checking then return end
  local ex = exercises[state.idx]
  if not ex then return end

  local filepath = vim.api.nvim_buf_get_name(state.buf or 0)
  if filepath == '' then
    vim.notify('[ferris] no file open', vim.log.levels.WARN)
    return
  end

  state.checking = true
  vim.diagnostic.reset(ns(), state.buf)
  ui.echo_checking()

  checker.check(filepath, function(ok, diags, message)
    state.checking = false
    vim.diagnostic.set(ns(), state.buf or 0, diags, {})
    if ok then
      progress.mark_complete(ex.id)
    end
    ui.echo_result(ok, message)
  end)
end

function M.hint()
  local ex = exercises[state.idx]
  if not ex then return end
  if state.hints_shown >= #ex.hints then
    vim.notify('[ferris] no more hints for this exercise', vim.log.levels.INFO)
    return
  end
  state.hints_shown = state.hints_shown + 1
  ui.show(ex, state.idx, #exercises, state.hints_shown)
end

function M.next()
  if state.idx >= #exercises then
    vim.notify('[ferris] 🎉 all exercises complete!', vim.log.levels.INFO)
    return
  end
  M.open(state.idx + 1)
end

function M.prev()
  if state.idx <= 1 then return end
  M.open(state.idx - 1)
end

function M.reset()
  local ex = exercises[state.idx]
  if not ex then return end
  progress.reset_file(ex.id, source_path(ex))
  M.open(state.idx)
  vim.notify('[ferris] exercise reset', vim.log.levels.INFO)
end

function M.chat()
  local ex = exercises[state.idx]
  if not ex then return end
  local filepath = progress.working_file(ex.id, source_path(ex))
  chat.open(ex, filepath)
end

function M.reset_all()
  progress.reset_all(exercises, source_path)
  state.idx = 1
  M.open(1)
  vim.notify('[ferris] all exercises reset', vim.log.levels.INFO)
end

function M.open_picker()
  setup_highlights()
  local prog  = progress.load()
  local items = {}
  for i, ex in ipairs(exercises) do
    local done = vim.tbl_contains(prog.completed, ex.id)
    table.insert(items, string.format('%s %2d  %s', done and '✓' or '○', i, ex.title))
  end

  vim.ui.select(items, { prompt = '🦀 Ferris — choose an exercise' }, function(_, idx)
    if idx then M.open(idx) end
  end)
end

function M.show_progress()
  local prog      = progress.load()
  local completed = #prog.completed
  local total     = #exercises
  local lines     = {
    '',
    string.format('  🦀 Ferris  —  %d / %d complete', completed, total),
    string.rep('─', 42),
    '',
  }
  for i, ex in ipairs(exercises) do
    local done = vim.tbl_contains(prog.completed, ex.id)
    local curr = i == state.idx and ' ←' or ''
    table.insert(lines, string.format('  %s  %2d  %s%s',
      done and '✓' or '○', i, ex.title, curr))
  end
  table.insert(lines, '')
  -- Echo with colour
  local out = {}
  for _, l in ipairs(lines) do
    local hl = l:match('✓') and 'FerrisSuccess' or 'Normal'
    table.insert(out, { l .. '\n', hl })
  end
  vim.api.nvim_echo(out, true, {})
end

-- Initialise state from saved progress on first require.
do
  local prog = progress.load()
  state.idx = math.max(1, math.min(prog.current or 1, #exercises))
end

return M
