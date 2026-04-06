-- Async rustc-based exercise checker.
-- Compiles with --test, runs the binary, reports pass/fail + diagnostics.

local M = {}

-- rustc --error-format=json emits one JSON object per line.
-- Top-level fields: message (string), code ({code,explanation}|null),
--                   level (string), spans (array), children (array).
local function parse_json_lines(lines)
  local parsed = {}
  for _, line in ipairs(lines) do
    if line ~= '' then
      local ok, obj = pcall(vim.json.decode, line)
      if ok and type(obj) == 'table' and type(obj.message) == 'string' then
        table.insert(parsed, obj)
      end
    end
  end
  return parsed
end

-- Convert parsed rustc diagnostics into vim.diagnostic entries.
local function parse_errors(lines)
  local diags = {}
  for _, obj in ipairs(parse_json_lines(lines)) do
    local level = obj.level or ''
    local sev = level == 'error'   and vim.diagnostic.severity.ERROR
             or level == 'warning' and vim.diagnostic.severity.WARN
             or vim.diagnostic.severity.HINT
    for _, span in ipairs(obj.spans or {}) do
      if span.is_primary then
        table.insert(diags, {
          lnum     = span.line_start - 1,
          col      = span.column_start - 1,
          end_lnum = span.line_end - 1,
          end_col  = span.column_end - 1,
          severity = sev,
          message  = obj.message,
          source   = 'rustc',
        })
      end
    end
  end
  return diags
end

-- Build a human-readable summary of the first compile error.
local function first_compile_error(lines)
  local count = 0
  local first_msg = nil
  for _, obj in ipairs(parse_json_lines(lines)) do
    if obj.level == 'error'
        and not obj.message:match('^aborting due to') then
      count = count + 1
      if not first_msg then
        local code = type(obj.code) == 'table' and obj.code.code
        first_msg = code
          and ('error[' .. code .. ']: ' .. obj.message)
          or  ('error: ' .. obj.message)
      end
    end
  end
  if not first_msg then return 'Compilation failed' end
  return count > 1
    and (first_msg .. string.format('  (+%d more)', count - 1))
    or   first_msg
end

-- Summarise test runner output into a short human message.
local function summarise_test_output(lines)
  for _, l in ipairs(lines) do
    if l:match('^test result') then return l end
  end
  for _, l in ipairs(lines) do
    if l:match('panicked') then
      -- "not yet implemented" means todo!() was hit
      if l:match('not yet implemented') then
        return 'Implement the function — todo!() was reached'
      end
      return l:match("'(.-)'") or l
    end
  end
  return table.concat(lines, ' '):sub(1, 120)
end

-- Run the exercise at `filepath` and call callback(ok, diagnostics, message).
function M.check(filepath, callback)
  -- Check rustc is available
  if vim.fn.executable('rustc') == 0 then
    callback(false, {}, 'rustc not found — is Rust installed?')
    return
  end

  local bin    = vim.fn.tempname()
  local errors = {}

  vim.fn.jobstart(
    { 'rustc', '--edition', '2021', '--test', '--error-format=json', '-o', bin, filepath },
    {
      stderr_buffered = true,
      on_stderr = function(_, data)
        for _, l in ipairs(data or {}) do
          if l ~= '' then table.insert(errors, l) end
        end
      end,
      on_exit = function(_, code)
        if code ~= 0 then
          local diags = parse_errors(errors)
          local msg   = first_compile_error(errors)
          vim.schedule(function()
            callback(false, diags, msg)
          end)
          return
        end

        -- Binary compiled — now run the tests.
        local out = {}
        vim.fn.jobstart({ bin }, {
          stdout_buffered = true,
          stderr_buffered = true,
          on_stdout = function(_, data)
            for _, l in ipairs(data or {}) do
              if l ~= '' then table.insert(out, l) end
            end
          end,
          on_stderr = function(_, data)
            for _, l in ipairs(data or {}) do
              if l ~= '' then table.insert(out, l) end
            end
          end,
          on_exit = function(_, test_code)
            vim.fn.delete(bin)
            vim.schedule(function()
              if test_code == 0 then
                callback(true, {}, 'All tests pass!')
              else
                callback(false, {}, summarise_test_output(out))
              end
            end)
          end,
        })
      end,
    }
  )
end

return M
