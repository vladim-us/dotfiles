return {
  {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      CustomOilBar = function()
        local path = vim.fn.expand '%'
        path = path:gsub('oil://', '')
        return '  ' .. vim.fn.fnamemodify(path, ':.')
      end

      require('oil').setup {
        columns = { 'icon' },
        keymaps = {
          ['<C-h>'] = false,
          ['<C-l>'] = false,
          ['<C-k>'] = false,
          ['<C-j>'] = false,
          ['<M-h>'] = 'actions.select_split',
        },
        win_options = {
          winbar = '%{v:lua.CustomOilBar()}',
          signcolumn = 'yes:2',
        },
        delete_to_trash = true,
        view_options = {
          show_hidden = true,
          is_always_hidden = function(name, _)
            local folder_skip = { 'dev-tools.locks', 'dune.lock', '_build' }
            return vim.tbl_contains(folder_skip, name)
          end,
        },
      }
      vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
    end,
  },
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    lazy = false,
    config = function()
      require('neo-tree').setup {
        close_if_last_window = true,
        popup_border_style = 'rounded',
        enable_git_status = true,
        enable_diagnostics = true,
        sources = { 'filesystem' },
        filesystem = {
          follow_current_file = {
            enabled = true,
            leave_dirs_open = true,
          },
          hijack_netrw_behavior = 'disabled',
          use_libuv_file_watcher = true,
          filtered_items = {
            visible = false,
            hide_dotfiles = false,
            hide_gitignored = true,
            hide_by_name = {
              '.DS_Store',
              'thumbs.db',
              'node_modules',
            },
            always_show = { '.gitignore' },
            never_show = { '.git' },
          },
        },
        window = {
          position = 'right',
          width = 30,
          mappings = {
            -- Disable navigation keys to prevent accidental use
            ['<cr>'] = 'noop',
            ['<2-LeftMouse>'] = 'noop',
            ['o'] = 'noop',
            ['<space>'] = 'noop',
            -- Keep other useful keys like refresh, etc.
            ['R'] = 'refresh',
            ['?'] = 'show_help',
          },
        },
      }

      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'oil',
        callback = function()
          local oil = require 'oil'
          local dir = oil.get_current_dir()
          if dir then
            require('neo-tree.command').execute {
              action = 'show',
              source = 'filesystem',
              position = 'right',
              reveal_file = dir,
              reveal_force_cwd = true,
            }
          end
        end,
      })
    end,
  },
  {
    'benomahony/oil-git.nvim',
    dependencies = { 'stevearc/oil.nvim' },
  },
}
