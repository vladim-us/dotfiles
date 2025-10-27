return {
  {
    'MagicDuck/grug-far.nvim',
    -- Note (lazy loading): grug-far.lua defers all it's requires so it's lazy by default
    -- additional lazy config to defer loading is not really needed...
    config = function()
      -- optional setup call to override plugin options
      -- alternatively you can set options with vim.g.grug_far = { ... }
      require('grug-far').setup {
        -- options, see Configuration section below
        -- there are no required options atm
      }
    end,
  },
  { 'NMAC427/guess-indent.nvim' },
  { 'matze/vim-move' },
  { 'mg979/vim-visual-multi' },
  {
    'mbbill/undotree',

    config = function()
      vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
    end,
  },
  {
    'kylechui/nvim-surround',
    version = '^3.0.0',
    event = 'VeryLazy',
    config = function()
      require('nvim-surround').setup {}
    end,
  },
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
  },
}
