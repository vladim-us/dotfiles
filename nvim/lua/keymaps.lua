vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'clear search highlight' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move"<CR>')
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- EXECUTE COMMANDS
vim.keymap.set('v', '<leader>el', ':lua<CR>', { desc = '[E]xecute [L]ua' })
--
-- LAUNCH COMMANDS
vim.keymap.set('n', '<leader>lg', '<cmd>LazyGit<CR>', { desc = '[L]aunch [G]it global' })

-- vim.keymap.set('n', '<leader>er', function()
--   local grug_far = require 'grug-far'
--   if not grug_far.has_instance 'explorer' then
--     grug_far.open { instanceName = 'explorer' }
--   else
--     grug_far.get_instance('explorer'):open()
--   end
--
--   -- if vim.bo.filetype == 'oil' then
--   local dir = require('oil').get_current_dir()
--   print(dir)
--   if dir then
--     local prefills = { paths = dir }
--     grug_far.get_instance('explorer'):update_input_values(prefills, false)
--   end
-- end, { desc = '[E]xecute [R]ename' })

-- TOGGLE COMMANDS

local themes = { 'rose-pine', 'melange', 'everforest' }
local current_theme_index = 1
vim.keymap.set('n', '<leader>ty', function()
  current_theme_index = current_theme_index % #themes + 1
  local new_theme = themes[current_theme_index]
  vim.cmd.colorscheme(new_theme)
  print('Switched to ' .. new_theme)
end, { desc = '[T]oggle [T]heme (rose-pine -> melange -> aura-dark -> everforest -> ...)' })
