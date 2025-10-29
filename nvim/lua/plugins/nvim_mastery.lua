return {
  {
    'tris203/precognition.nvim',
    enabled = true,
    event = 'VeryLazy',
  },
  {
    'm4xshen/hardtime.nvim',
    lazy = false,
    dependencies = { 'MunifTanjim/nui.nvim' },
    opts = {
      disable_mouse = false,
      disabled_keys = {
        ['<Up>'] = { '', 'n' },
        ['<Down>'] = { '', 'n' },
        ['<Left>'] = { '', 'n' },
        ['<Right>'] = { '', 'n' },
      },
    },
  },
  {
    'tris203/hawtkeys.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
  },
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    keys = {
      {
        '<leader>?',
        function()
          require('which-key').show { global = false }
        end,
        desc = 'Buffer Local Keymaps (which-key)',
      },
    },
  },
}
