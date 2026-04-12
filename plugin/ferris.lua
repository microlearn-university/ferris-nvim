if vim.g.loaded_ferris then return end
vim.g.loaded_ferris = true

local function load() return require('ferris') end

vim.api.nvim_create_user_command('Ferris',         function()    load().open_picker()  end, { desc = 'Open Ferris exercise picker' })
vim.api.nvim_create_user_command('FerrisNext',     function()    load().next()         end, { desc = 'Next exercise' })
vim.api.nvim_create_user_command('FerrisPrev',     function()    load().prev()         end, { desc = 'Previous exercise' })
vim.api.nvim_create_user_command('FerrisHint',     function()    load().hint()         end, { desc = 'Show next hint' })
vim.api.nvim_create_user_command('FerrisCheck',    function()    load().check()        end, { desc = 'Check current exercise' })
vim.api.nvim_create_user_command('FerrisProgress', function()    load().show_progress() end, { desc = 'Show progress' })
vim.api.nvim_create_user_command('FerrisReset',    function()    load().reset()        end, { desc = 'Reset exercise to original' })
vim.api.nvim_create_user_command('FerrisResetAll', function()    load().reset_all()    end, { desc = 'Reset all exercises and progress' })
vim.api.nvim_create_user_command('FerrisChat',     function()    load().chat()         end, { desc = 'Chat with Ferris about this exercise' })
