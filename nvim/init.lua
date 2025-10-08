require 'options'

require 'keymaps'

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
      vim.cmd.colorscheme 'rose-pine'
      -- vim.cmd.colorscheme 'rose-pine-moon'
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

require('lualine').setup()
require('actions-preview').setup()
