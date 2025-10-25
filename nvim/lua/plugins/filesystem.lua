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
        },
        view_options = {
          show_hidden = true,
          is_always_hidden = function(name, _)
            local folder_skip = { 'dev-tools.locks', 'dune.lock', '_build' }
            return vim.tbl_contains(folder_skip, name)
          end,
        },
      }

      -- Open parent directory
      vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })

      -- Open parent directory in floating window
      -- vim.keymap.set('n', '<space>-', require('oil').toggle_float)

      vim.keymap.set('n', '<leader>o', function()
        -- Check if the current buffer is an Oil buffer
        if vim.bo.filetype == 'oil' then
          -- Get the current directory from Oil
          local oil = require 'oil'
          local dir = oil.get_current_dir()

          if dir then
            local cmd
            if vim.fn.has 'win32' == 1 then
              -- Windows: Use explorer
              cmd = string.format('!explorer "%s"', dir)
            elseif vim.fn.has 'mac' == 1 then
              -- macOS: Use open
              cmd = string.format('!open "%s"', dir)
            else
              -- Linux: Use xdg-open
              cmd = string.format('!xdg-open "%s"', dir)
            end
            vim.cmd(cmd)
          else
            print 'Oil: Could not determine current directory'
          end
        else
          print 'Not an Oil buffer'
        end
      end, { desc = 'Open system file explorer for current Oil directory' })

      vim.keymap.set('n', '<leader>rnf', function()
        -- Get the current directory from Oil
        local oil = require 'oil'
        local dir = oil.get_current_dir()
      end, { desc = '[R]ename in [F]iles' })
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
          position = 'left',
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

      -- Keymap to toggle the sidebar
      vim.keymap.set('n', '<leader>te', ':Neotree toggle reveal filesystem left<CR>', { desc = 'Toggle Directory Sidebar' })

      -- Optional: Sync with Oil - When entering Oil, reveal in Neo-tree
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'oil',
        callback = function()
          local oil = require 'oil'
          local dir = oil.get_current_dir()
          if dir then
            require('neo-tree.command').execute {
              action = 'show',
              source = 'filesystem',
              position = 'left',
              reveal_file = dir,
              reveal_force_cwd = true,
            }
          end
        end,
      })
    end,
  },
  { 'nvzone/volt', lazy = true },
  { 'nvzone/menu', lazy = true },
  {
    'tpope/vim-vinegar',
    enabled = false,
  },
}
