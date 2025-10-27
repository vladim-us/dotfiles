require 'options'
-- todo bla

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
    end,
  },
  {
    'savq/melange-nvim',
    priority = 1000,
  },
  {
    'sainnhe/everforest',
    priority = 1000,
    config = function()
      vim.g.everforest_background = 'hard'
      vim.g.everforest_enable_italic = 1
      vim.g.everforest_disable_italic_comments = 1
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

require('lualine').setup()
require('actions-preview').setup()
