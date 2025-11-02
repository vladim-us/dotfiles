return {
  { 'dstein64/nvim-scrollview' },
  {
    'sphamba/smear-cursor.nvim',
    event = 'VeryLazy',
    cond = vim.g.neovide == nil,
    opts = {
      hide_target_hack = true,
      cursor_color = 'none',
      stiffness = 0.8,
      trailing_stifness = 0.5,
      distance_stop_animating = 0.5,
    },
    specs = {
      {
        'echasnovski/mini.animate',
        optional = true,
        opts = {
          cursor = { enable = false },
        },
      },
    },
  },
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },
  { 'akinsho/toggleterm.nvim', version = '*', config = true },
  {
    'karb94/neoscroll.nvim',
    opts = {
      easing = 'quadratic',
    },
  },
}
