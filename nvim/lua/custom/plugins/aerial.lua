return {
  'stevearc/aerial.nvim',
  opts = {
    open_automatic = function(bufnr)
      -- Enforce a minimum line count
      return false
        and vim.api.nvim_buf_line_count(bufnr) > 80
        -- Enforce a minimum symbol count
        and aerial.num_symbols(bufnr) > 4
        -- A useful way to keep aerial closed when closed manually
        and not aerial.was_closed()
    end,
  },
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
}
