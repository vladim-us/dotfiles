return {
  {
    'RRethy/vim-illuminate',
    opts = {
      providers = { 'lsp', 'treesitter', 'regex' }, -- Prioritize LSP/Treesitter for accuracy
      delay = 20,
      filetypes_denylist = { 'dirvish', 'fugitive', 'NvimTree' },
      under_cursor = true,
      large_file_cutoff = 10000,
      large_file_overrides = nil,
      min_count_to_highlight = 1,
    },
    config = function(_, opts)
      require('illuminate').configure(opts)
      vim.api.nvim_set_hl(0, 'IlluminatedWordText', { underline = true })
      vim.api.nvim_set_hl(0, 'IlluminatedWordRead', { underline = true })
      vim.api.nvim_set_hl(0, 'IlluminatedWordWrite', { underline = true, bold = true })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs',
    opts = {
      ensure_installed = {
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
        'json',
        'yaml',
        'toml',
      },
      sync_install = false,
      auto_install = true,
      highlight = { enable = true },
      indent = {
        enable = true,
        disable = { 'ruby', 'python', 'c' },
      },
    },
  },
  {
    'kevinhwang91/nvim-ufo',
    dependencies = 'kevinhwang91/promise-async',
    event = 'VeryLazy',
    opts = {
      provider_selector = function()
        return { 'treesitter', 'indent' }
      end,
    },
    config = function(_, opts)
      require('ufo').setup(opts)
      vim.o.foldcolumn = '1'
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      local map = vim.keymap.set
      -- map('n', 'za', 'za', { desc = 'Toggle ffold ' })
      map('n', 'zc', 'zc', { desc = 'Close ffold' })
      map('n', 'zo', 'zo', { desc = 'Open ffold' })
      map('n', 'zR', require('ufo').openAllFolds, { desc = 'Open all folds' })
      map('n', 'zM', require('ufo').closeAllFolds, { desc = 'Close all folds' })
    end,
  },
  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      icons = true,
      auto_preview = true,
      modes = {
        lsp_incoming_calls = { mode = 'lsp_incoming_calls', focus = false },
        lsp_outgoing_calls = { mode = 'lsp_outgoing_calls', focus = false },
        treesitter_symbols = {
          desc = 'Treesitter Symbols (Fallback for non-LSP)',
          mode = 'symbols',
          win = { position = 'right' },
          filter = {
            any = {
              kind = { 'Class', 'Function', 'Method', 'Interface', 'Module', 'Property' },
            },
          },
          format = '{kind_icon}{symbol.name:Normal}',
        },
      },
    },
    cmd = 'Trouble',
    keys = {
      { '<leader>qx', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics (Trouble)' },
      { '<leader>qX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Buffer Diagnostics (Trouble)' },
      { '<leader>qs', '<cmd>Trouble symbols toggle focus=false<cr>', desc = 'Symbols (Trouble)' },
      { '<leader>ql', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>', desc = 'LSP Definitions / references / ... (Trouble)' },
      { '<leader>qL', '<cmd>Trouble loclist toggle<cr>', desc = 'Location List (Trouble)' },
      { '<leader>qQ', '<cmd>Trouble qflist toggle<cr>', desc = 'Quickfix List (Trouble)' },
      { '<leader>qt', '<cmd>Trouble treesitter_symbols toggle focus=false win.position=right<cr>', desc = 'Treesitter Symbols (Trouble)' },
    },
  },
}
