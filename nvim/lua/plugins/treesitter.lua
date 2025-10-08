return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  main = 'nvim-treesitter.configs',
  opts = {
    -- Broader parsers; swap "maintained" for "all" if you want everything
    ensure_installed = {
      'maintained', -- Or add specifics: "json", "yaml", "typescript", "tsx", "go", "toml"
      'nu',
      'python',
      'rust',
      'bash',
      'c',
      'diff',
      'html',
      'lua',
      'luadoc',
      'markdown',
      'markdown_inline',
      'query',
      'vim',
      'vimdoc',
    },
    auto_install = true,
    highlight = {
      enable = true,
      -- Disable for large files to avoid perf hits
      disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          return true
        end
      end,
      additional_vim_regex_highlighting = false, -- Drop Ruby fallback; Tree-sitter handles it
    },
    indent = {
      enable = true,
      disable = { 'ruby', 'python', 'c' }, -- Extend if needed
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<C-space>', -- Or your preferred (defaults: gnn, etc.)
        node_incremental = '<C-space>',
        scope_incremental = false,
        node_decremental = false,
      },
    },
  },
  config = function()
    -- Folding setup (add to your init.lua or here)
    vim.opt.foldmethod = 'expr'
    vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
    vim.opt.foldlevel = 99 -- Start unfolded
  end,
}
