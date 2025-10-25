require 'options'
-- todo bla
local themes = { 'rose-pine', 'melange', 'everforest' }
local current_theme_index = 1

local function switch_theme()
  current_theme_index = current_theme_index % #themes + 1
  local new_theme = themes[current_theme_index]
  vim.cmd.colorscheme(new_theme)
  print('Switched to ' .. new_theme)
end

require('lazy').setup({
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    priority = 1000,
    opts = {},
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('rose-pine').setup {
        -- variant = 'moon',
        -- dark_variant = 'moon',
      }
      -- Don't apply here; we'll apply manually
    end,
  },
  {
    'savq/melange-nvim',
    priority = 1000,
    -- No opts or config needed; just install and use :colorscheme melange
  },
  {
    'sainnhe/everforest',
    priority = 1000,
    config = function()
      -- Set global options for everforest (applied on load)
      vim.g.everforest_background = 'hard'
      vim.g.everforest_enable_italic = 1
      vim.g.everforest_disable_italic_comments = 1
      -- Don't apply here; we'll apply manually
    end,
  },
  { import = 'plugins' },
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- Apply initial theme
vim.cmd.colorscheme 'melange'

require 'keymaps'

-- Add this to your keymaps.lua file, or here if preferred
vim.keymap.set('n', '<leader>ty', switch_theme, { desc = '[T]oggle [T]heme (rose-pine -> melange -> aura-dark -> everforest -> ...)' })

require('lualine').setup()
require('actions-preview').setup()
