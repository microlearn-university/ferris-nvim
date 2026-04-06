local M = {}

local function data_dir()
  return vim.fn.stdpath('data') .. '/ferris-nvim'
end

local function progress_file()
  return data_dir() .. '/progress.json'
end

local function exercises_dir()
  return data_dir() .. '/exercises'
end

function M.load()
  local f = progress_file()
  if vim.fn.filereadable(f) == 0 then
    return { completed = {}, current = 1 }
  end
  local lines = vim.fn.readfile(f)
  local ok, data = pcall(vim.json.decode, table.concat(lines, '\n'))
  if ok and data then return data end
  return { completed = {}, current = 1 }
end

function M.save(data)
  vim.fn.mkdir(data_dir(), 'p')
  vim.fn.writefile({ vim.json.encode(data) }, progress_file())
end

function M.mark_complete(id)
  local data = M.load()
  if not vim.tbl_contains(data.completed, id) then
    table.insert(data.completed, id)
  end
  M.save(data)
end

function M.is_complete(id)
  return vim.tbl_contains(M.load().completed, id)
end

-- Return the path to the user's working copy of an exercise.
-- Creates it from the source on first access.
function M.working_file(id, source_path)
  vim.fn.mkdir(exercises_dir(), 'p')
  local dest = exercises_dir() .. '/' .. id .. '.rs'
  if vim.fn.filereadable(dest) == 0 then
    vim.fn.system({ 'cp', source_path, dest })
  end
  return dest
end

function M.reset_file(id, source_path)
  vim.fn.mkdir(exercises_dir(), 'p')
  local dest = exercises_dir() .. '/' .. id .. '.rs'
  vim.fn.system({ 'cp', source_path, dest })
  return dest
end

return M
