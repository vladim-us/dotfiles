return {
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
    -- keymap('n', '<leader>gc', fzf.git_commits, { desc = 'Search [G]it [C]ommits' })
    -- keymap('n', '<leader>gcf', fzf.git_bcommits, { desc = 'Search [G]it [C]ommits for current [F]ile' })
    -- keymap('n', '<leader>tgb', fzf.git_branches, { desc = 'Search [G]it [B]ranches' })
    -- keymap('n', '<leader>gs', fzf.git_status, { desc = 'Search [G]it [S]tatus (diff view)' })
    keymap('n', '<leader>ff', fzf.files, { desc = '[F]ind [F]iles' })
    -- keymap('n', '<leader>sh', fzf.help_tags, { desc = '[S]earch [H]elp' })
    -- keymap('n', '<leader>scw', fzf.grep_cword, { desc = '[S]earch current [W]ord' })
    keymap('n', '<leader>ft', fzf.live_grep, { desc = '[F]ind [T]ext' })
    -- keymap('n', '<leader>fd', fzf.diagnostics_document, { desc = '[S]earch [D]iagnostics' })
    keymap('n', '<leader>fr', fzf.resume, { desc = '[F]ind [R]esume' })
    -- keymap('n', '<leader>fo', fzf.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
    -- keymap('n', '<leader>qf', fzf.quickfix, { desc = 'Show quick fix list' })
    -- keymap('n', '<leader>ft', function()
    -- 	fzf.grep { cmd = 'rg --column --line-number', search = 'TODO', prompt = 'Todos> ' }
    -- end, { desc = 'Find todos' })
    keymap('n', '<leader>fs', function()
      fzf.lsp_document_symbols {
        symbol_types = { 'Class', 'Function', 'Method', 'Constructor', 'Interface', 'Module', 'Property' },
      }
    end, { desc = '[Find] LSP [S]ymbols' })
    -- keymap('n', '<leader><leader>', fzf.buffers, { desc = 'Find existing buffers' })
    -- keymap('n', '<leader>s/', function()
    -- 	fzf.live_grep { buffers_only = true, prompt = 'Live Grep in Open Files> ' }
    -- end, { desc = '[S]earch [/] in Open Files' })
    keymap('n', '<leader>/', function()
      fzf.blines { previewer = false }
    end, { desc = 'Fuzzily search in current buffer' })
  end,
}
