return {
  {
    'romgrk/barbar.nvim',
    dependencies = {
      'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
      'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
    },
    init = function()
      vim.g.barbar_auto_setup = true
    end,
    opts = {
      animation = true,
      auto_hide = false,
      tabpages = true,
      clickable = true,
      exclude_ft = { 'javascript' },
      exclude_name = { 'package.json' },
      focus_on_close = 'left',
      hide = { extensions = true, inactive = true },
      highlight_alternate = false,
      highlight_inactive_file_icons = false,
      highlight_visible = true,
      icons = {
        buffer_index = false,
        buffer_number = false,
        button = '',
        diagnostics = {
          [vim.diagnostic.severity.ERROR] = { enabled = true, icon = 'ﬀ' },
          [vim.diagnostic.severity.WARN] = { enabled = false },
          [vim.diagnostic.severity.INFO] = { enabled = false },
          [vim.diagnostic.severity.HINT] = { enabled = true },
        },
        gitsigns = {
          added = { enabled = true, icon = '+' },
          changed = { enabled = true, icon = '~' },
          deleted = { enabled = true, icon = '-' },
        },
        filetype = {
          custom_colors = false,
          enabled = true,
        },
        separator = { left = '▎', right = '' },
        separator_at_end = true,
        modified = { button = '●' },
        pinned = { button = '', filename = true },
        preset = 'default',
        alternate = { filetype = { enabled = false } },
        current = { buffer_index = true },
        inactive = { button = '×' },
        visible = { modified = { buffer_number = false } },
      },
    },
    version = '^1.0.0',

    config = function()
      local map = vim.keymap.set
      local opts = { noremap = true, silent = true }
      map('n', '<A-,>', '<Cmd>BufferPrevious<CR>', opts)
      map('n', '<A-.>', '<Cmd>BufferNext<CR>', opts)

      map('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', opts)
      map('n', '<A->>', '<Cmd>BufferMoveNext<CR>', opts)

      map('n', '<A-1>', '<Cmd>BufferGoto 1<CR>', opts)
      map('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', opts)
      map('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', opts)
      map('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', opts)
      map('n', '<A-5>', '<Cmd>BufferGoto 5<CR>', opts)
      map('n', '<A-6>', '<Cmd>BufferGoto 6<CR>', opts)
      map('n', '<A-7>', '<Cmd>BufferGoto 7<CR>', opts)
      map('n', '<A-8>', '<Cmd>BufferGoto 8<CR>', opts)
      map('n', '<A-9>', '<Cmd>BufferGoto 9<CR>', opts)
      map('n', '<A-0>', '<Cmd>BufferLast<CR>', opts)

      map('n', '<A-p>', '<Cmd>BufferPin<CR>', opts)
      map('n', '<A-c>', '<Cmd>BufferClose<CR>', opts)
    end,
  },

  {
    'otavioschwanck/arrow.nvim',
    dependencies = {
      { 'nvim-tree/nvim-web-devicons' },
    },
    opts = {
      show_icons = true,
      leader_key = ';', -- Recommended to be a single key
      buffer_leader_key = 'm', -- Per Buffer Mappings
    },
  },

  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    ---@type Flash.Config
    opts = {
      modes = {
        treesitter = {
          label = { rainbow = { enabled = true } }, -- Enable rainbow for visualizing ranges
        },
      },
    },
    keys = {
      {
        's',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').jump()
        end,
        desc = 'Flash',
      },
      {
        'S',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').treesitter()
        end,
        desc = 'Flash Treesitter',
      },
      -- {
      --   'r',
      --   mode = 'o',
      --   function()
      --     require('flash').remote()
      --   end,
      --   desc = 'Remote Flash',
      -- },
      -- {
      --   'R',
      --   mode = { 'o', 'x' },
      --   function()
      --     require('flash').treesitter_search()
      --   end,
      --   desc = 'Treesitter Search',
      -- },
      {
        '<c-s>',
        mode = { 'c' },
        function()
          require('flash').toggle()
        end,
        desc = 'Toggle Flash Search',
      },
      -- New: Incremental Treesitter selection with textobjects
      {
        '<c-space>',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').treesitter {
            labels = 'abcdefghijklmnopqrstuvwxyz',
            search = { multi_window = false, wrap = false, incremental = true },
            actions = {
              ['<c-space>'] = 'next',
              ['<BS>'] = 'prev',
            },
          }
        end,
        desc = 'Treesitter Incremental Selection (e.g., expand to function/class)',
      },
    },
  },

  {
    'ibhagwan/fzf-lua',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      local fzf = require 'fzf-lua'

      fzf.setup {
        {
          'fzf-native',
          winopts = {
            preview = { default = 'bat' },
          },
        },
        keymap = {
          fzf = {
            ['ctrl-u'] = 'preview-page-up',
            ['ctrl-d'] = 'preview-page-down',
            ['ctrl-k'] = 'up',
            ['ctrl-j'] = 'down',
            ['ctrl-q'] = 'abort',
          },
        },
        files = {
          fd_opts = '--type f --hidden --exclude node_modules --exclude .git --exclude .venv',
          previewer = 'bat',
        },
        buffers = {
          sort_lastused = true,
          previewer = 'bat',
        },
        grep = {
          cmd = 'rg --line-number --column --no-heading --color=always --smart-case',
          rg_opts = '--hidden --glob "!node_modules/*" --glob "!.git/*" --glob "!.venv/*"',
          previewer = 'bat',
        },
        live_grep = {
          cmd = 'rg --line-number --column --no-heading --color=always --smart-case',
          rg_opts = '--hidden --glob "!node_modules/*" --glob "!.git/*" --glob "!.venv/*"',
          previewer = 'bat',
        },
        git = {
          files = {
            previewer = 'bat',
          },
        },
        fzf_opts = {
          ['--tiebreak'] = 'index',
        },
        defaults = {
          git_icons = true,
          file_icons = true,
          color_icons = true,
        },
      }
      fzf.register_ui_select()

      local keymap = vim.keymap.set

      keymap('n', '<leader>fr', fzf.resume, { desc = '[F]ind [R]esume' })

      -- Find Text
      keymap('n', '<leader>ff', function()
        fzf.live_grep { cwd = require('oil').get_current_dir() }
      end, { desc = '[F]ind Text in current [D]irectory' })
      keymap('n', '<leader>fF', fzf.live_grep, { desc = '[F]ind text' })
      keymap('v', '<leader>ff', function()
        require('fzf-lua').grep_visual()
      end, { desc = '[F]ind text from visual selection' })

      keymap('n', '<leader>fs', function()
        fzf.lsp_document_symbols {
          symbol_types = { 'Class', 'Function', 'Method', 'Constructor', 'Interface', 'Module', 'Property' },
        }
      end, { desc = '[Find] LSP [S]ymbols' })

      -- Find files
      keymap('n', '<leader>fg', fzf.git_files, { desc = '[F]ind [G]it Files' })
      keymap('n', '<leader>fD', fzf.files, { desc = '[F]ind [D]irectory Files' })
      keymap('v', '<leader>fD', fzf.files, { desc = '[F]ind [D]irectory Files' })
      keymap('n', '<leader>fd', function()
        fzf.files { cwd = require('oil').get_current_dir() }
      end, { desc = '[F]ind in current [D]irectory' })
      keymap('n', '<leader>fR', fzf.oldfiles, { desc = '[F]ind [Recent] Files' })

      -- keymap('n', '<leader>fb', fzf.buffers, { desc = '[S]earch existing [B]uffers' })
      -- keymap('n', '<leader>fm', fzf.marks, { desc = '[S]earch [M]arks' })
      -- keymap('n', '<leader>fq', fzf.quickfix, { desc = 'Show quick fix list' })
      -- keymap('n', '<leader>gc', fzf.git_commits, { desc = 'Search [G]it [C]ommits' })
      -- keymap('n', '<leader>gcf', fzf.git_bcommits, { desc = 'Search [G]it [C]ommits for current [F]ile' })
      -- keymap('n', '<leader>tgb', fzf.git_branches, { desc = 'Search [G]it [B]ranches' })
      -- keymap('n', '<leader>gs', fzf.git_status, { desc = 'Search [G]it [S]tatus (diff view)' })
      -- keymap('n', '<leader>sh', fzf.help_tags, { desc = '[S]earch [H]elp' })
      -- keymap('n', '<leader>scw', fzf.grep_cword, { desc = '[S]earch current [W]ord' })
      -- keymap('n', '<leader>fd', fzf.diagnostics_document, { desc = '[S]earch [D]iagnostics' })
      -- keymap('n', '<leader>ft', function()
      -- 	fzf.grep { cmd = 'rg --column --line-number', search = 'TODO', prompt = 'Todos> ' }
      -- end, { desc = 'Find todos' })
      -- keymap('n', '<leader><leader>', fzf.buffers, { desc = 'Find existing buffers' })
      -- keymap('n', '<leader>s/', function()
      -- 	fzf.live_grep { buffers_only = true, prompt = 'Live Grep in Open Files> ' }
      -- end, { desc = '[S]earch [/] in Open Files' })
      keymap('n', '/', function()
        fzf.blines { previewer = false }
      end, { desc = 'Fuzzily search in current buffer' })
    end,
  },
}
