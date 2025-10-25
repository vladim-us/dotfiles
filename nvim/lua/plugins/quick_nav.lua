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
      -- Enable/disable animations
      animation = true,
      -- Automatically hide the tabline when there are this many buffers left.
      auto_hide = false,
      -- Enable/disable current/total tabpages indicator (top right corner)
      tabpages = true,
      -- Enables/disable clickable tabs
      clickable = true,
      -- Excludes buffers from the tabline
      exclude_ft = { 'javascript' },
      exclude_name = { 'package.json' },
      -- A buffer to this direction will be focused (if it exists) when closing the current buffer.
      focus_on_close = 'left',
      -- Hide inactive buffers and file extensions. Other options are `alternate`, `current`, and `visible`.
      hide = { extensions = true, inactive = true },
      -- Disable highlighting alternate buffers
      highlight_alternate = false,
      -- Disable highlighting file icons in inactive buffers
      highlight_inactive_file_icons = false,
      -- Enable highlighting visible buffers
      highlight_visible = true,
      icons = {
        -- Configure the base icons on the bufferline.
        buffer_index = false,
        buffer_number = false,
        button = '',
        -- Enables / disables diagnostic symbols
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
          -- Sets the icon's highlight group.
          -- If false, will use nvim-web-devicons colors
          custom_colors = false,
          -- Requires `nvim-web-devicons` if `true`
          enabled = true,
        },
        separator = { left = '▎', right = '' },
        -- If true, add an additional separator at the end of the buffer list
        separator_at_end = true,
        -- Configure the icons on the bufferline when modified or pinned.
        modified = { button = '●' },
        pinned = { button = '', filename = true },
        -- Use a preconfigured buffer appearance— can be 'default', 'powerline', or 'slanted'
        preset = 'default',
        -- Configure the icons on the bufferline based on the visibility of a buffer.
        alternate = { filetype = { enabled = false } },
        current = { buffer_index = true },
        inactive = { button = '×' },
        visible = { modified = { buffer_number = false } },
      },
    },
    version = '^1.0.0', -- optional: only update when a new 1.x version is released

    config = function()
      local map = vim.keymap.set
      local opts = { noremap = true, silent = true }
      -- Move to previous/next
      map('n', '<A-,>', '<Cmd>BufferPrevious<CR>', opts)
      map('n', '<A-.>', '<Cmd>BufferNext<CR>', opts)

      -- Re-order to previous/next
      map('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', opts)
      map('n', '<A->>', '<Cmd>BufferMoveNext<CR>', opts)

      -- Go buffer in position...
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

      -- Pin/unpin buffer
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

      -- keymap('n', '<leader>fb', fzf.buffers, { desc = '[S]earch existing [B]uffers' })
      -- keymap('n', '<leader>fm', fzf.marks, { desc = '[S]earch [M]arks' })
      keymap('n', '<leader>fg', fzf.git_files, { desc = '[F]ind [G]it Files' })
      keymap('n', '<leader>fd', fzf.files, { desc = '[F]ind [D]irectory Files' })
      keymap('n', '<leader>ff', fzf.live_grep, { desc = '[F]ind text' })
      keymap('n', '<leader>fr', fzf.resume, { desc = '[F]ind [R]esume' })
      keymap('n', '<leader>fo', fzf.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      keymap('n', '<leader>fs', function()
        fzf.lsp_document_symbols {
          symbol_types = { 'Class', 'Function', 'Method', 'Constructor', 'Interface', 'Module', 'Property' },
        }
      end, { desc = '[Find] LSP [S]ymbols' })
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
