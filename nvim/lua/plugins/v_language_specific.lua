return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
  {
    'lervag/vimtex',
    lazy = false, -- Important: Do not lazy-load VimTeX to avoid breaking inverse search
    init = function()
      -- Basic config goes here (see below)
    end,
  },
}
