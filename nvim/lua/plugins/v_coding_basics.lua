return {
  {
    'RRethy/vim-illuminate',
    opts = {
      providers = { 'lsp', 'treesitter', 'regex' }, -- Prioritize LSP/Treesitter for accuracy
      delay = 100, -- Default, but adjustable for snappier feel (e.g., 50ms)
      filetypes_denylist = { 'dirvish', 'fugitive', 'NvimTree' }, -- Add more if you have file explorers
      under_cursor = true,
      large_file_cutoff = 10000, -- Disable for large files to avoid slowdown
      large_file_overrides = nil, -- Fully disable for large files
      min_count_to_highlight = 1,
    },
    config = function(_, opts)
      require('illuminate').configure(opts)
      -- Custom highlights (add to your colorscheme or here)
      vim.api.nvim_set_hl(0, 'IlluminatedWordText', { underline = true })
      vim.api.nvim_set_hl(0, 'IlluminatedWordRead', { underline = true })
      vim.api.nvim_set_hl(0, 'IlluminatedWordWrite', { underline = true, bold = true })
    end,
  },
  {
    'smjonas/inc-rename.nvim',
    opts = {
      hl_group = 'Substitute',
      preview_empty_name = true,
      show_message = true,
      input_buffer_type = nil, -- Or 'dressing' if you add it
      -- New: Post-hook to refresh lspsaga after rename
      post_hook = function()
        require('lspsaga').init_lsp_saga() -- Or custom refresh if needed
      end,
    },
    keys = {
      {
        '<leader>lrn',
        function()
          return ':IncRename ' .. vim.fn.expand '<cword>'
        end,
        expr = true,
        desc = 'Incremental Rename (with Preview)',
      },
    },
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects', -- New: For advanced selections
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
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
        'toml', -- New: Common config formats
      },
      sync_install = false, -- Async for better UX during setup
      auto_install = true,
      highlight = { ... }, -- Your existing
      indent = {
        enable = true,
        disable = { 'ruby', 'python', 'c' }, -- Your existing; note: Python indent is experimental, consider enabling if stable
      },
      incremental_selection = { ... }, -- Your existing
      textobjects = { -- New module
        select = {
          enable = true,
          lookahead = true, -- Jump to next if not under cursor
          keymaps = {
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
            ['ap'] = '@parameter.outer',
            ['ip'] = '@parameter.inner',
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- Add to jumplist
          goto_next_start = {
            [']m'] = '@function.outer',
            [']]'] = '@class.outer',
          },
          goto_previous_start = {
            ['[m'] = '@function.outer',
            ['[['] = '@class.outer',
          },
        },
      },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
      -- Your folding setup
      vim.opt.foldmethod = 'expr'
      vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      vim.opt.foldlevel = 99
    end,
  },

  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      icons = true,
      auto_preview = true,
      modes = {
        -- Your existing modes...
        lsp_incoming_calls = { mode = 'lsp_incoming_calls', focus = false },
        lsp_outgoing_calls = { mode = 'lsp_outgoing_calls', focus = false },
        -- New: Treesitter-based symbols mode
        treesitter_symbols = {
          desc = 'Treesitter Symbols (Fallback for non-LSP)',
          mode = 'symbols', -- Base on symbols mode
          win = { position = 'right' },
          filter = {
            any = {
              kind = { 'Class', 'Function', 'Method', 'Interface', 'Module', 'Property' }, -- Treesitter kinds
            },
          },
          format = '{kind_icon}{symbol.name:Normal}', -- Display with icons
          -- Use Treesitter for parsing (trouble falls back if no LSP)
        },
      },
    },
    cmd = 'Trouble',
    keys = {
      -- Your existing keys...
      { '<leader>lqx', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics (Trouble)' },
      { '<leader>lqX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Buffer Diagnostics (Trouble)' },
      { '<leader>lqs', '<cmd>Trouble symbols toggle focus=false<cr>', desc = 'Symbols (Trouble)' },
      { '<leader>lql', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>', desc = 'LSP Definitions / references / ... (Trouble)' },
      { '<leader>lqL', '<cmd>Trouble loclist toggle<cr>', desc = 'Location List (Trouble)' },
      { '<leader>lqQ', '<cmd>Trouble qflist toggle<cr>', desc = 'Quickfix List (Trouble)' },
      -- New: Key for Treesitter symbols
      { '<leader>lqt', '<cmd>Trouble treesitter_symbols toggle focus=false win.position=right<cr>', desc = 'Treesitter Symbols (Trouble)' },
    },
  },
}
