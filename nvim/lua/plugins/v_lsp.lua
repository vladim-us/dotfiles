return {
  -- Mason: Tool installer for LSP servers, linters, and formatters
  {
    'mason-org/mason.nvim',
    cmd = { 'Mason', 'MasonInstall', 'MasonUninstall', 'MasonUninstallAll', 'MasonLog' },
    opts = {
      PATH = 'prepend', -- How to add installed tools to PATH
      ensure_installed = { 'stylua', 'rustfmt' }, -- Auto-install formatters
      ui = {
        icons = {
          package_installed = '✓',
          package_pending = '➜',
          package_uninstalled = '✗',
        },
      },
    },
  },
  -- Mason-LSPConfig: Bridges Mason and nvim-lspconfig (v2.0+ style)
  {
    'mason-org/mason-lspconfig.nvim',
    dependencies = { 'mason-org/mason.nvim', 'neovim/nvim-lspconfig', 'saghen/blink.cmp' },
    config = function()
      require('mason-lspconfig').setup {
        ensure_installed = {
          'lua_ls',
          'basedpyright',
          'rust_analyzer',
          'ruff',
        },
        automatic_enable = true, -- Auto-enables installed servers
      }
    end,
  },
  -- LSP Saga: Improves Neovim LSP experience with UI enhancements
  {
    'nvimdev/lspsaga.nvim',
    event = 'LspAttach',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    opts = {
      ui = {
        border = 'rounded',
      },
    },
    config = function(_, opts)
      require('lspsaga').setup(opts)
    end,
  },
  -- Conform: Dedicated async formatter
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' }, -- Lazy-load on save
    opts = {
      formatters_by_ft = {
        lua = { 'stylua' }, -- Replaces none-ls stylua
        python = { 'ruff_format' }, -- Explicit for Ruff CLI; fallback to LSP
        rust = { 'rustfmt' }, -- CLI fallback to rust_analyzer
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true, -- Uses Ruff LSP if no CLI formatter
      },
      default_format_opts = { lsp_fallback = true },
    },
  },
  -- LSPConfig: Core LSP client configurations
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'mason-org/mason.nvim',
      'mason-org/mason-lspconfig.nvim',
      'saghen/blink.cmp', -- For capabilities, since you use blink.cmp
      'nvimdev/lspsaga.nvim',
    },
    config = function()
      -- Setup capabilities (integrate with blink.cmp)
      local capabilities = vim.tbl_deep_extend('force', vim.lsp.protocol.make_client_capabilities(), require('blink.cmp').get_lsp_capabilities())
      -- Global on_attach function
      local on_attach = function(client, bufnr)
        -- Keymaps
        local bufopts = { buffer = bufnr, noremap = true, silent = true }
        -- Go-tos
        vim.keymap.set('n', 'gtd', '<cmd>Lspsaga goto_definition<CR>', vim.tbl_extend('force', bufopts, { desc = 'Go [T]o Definition' }))
        vim.keymap.set('n', 'gtD', '<cmd>Lspsaga goto_declaration<CR>', vim.tbl_extend('force', bufopts, { desc = 'Go [T]o [D]eclaration' }))

        vim.keymap.set('n', 'gtt', '<cmd>Lspsaga goto_type_definition<CR>', vim.tbl_extend('force', bufopts, { desc = 'Go [T]o [T]ype definition' }))
        vim.keymap.set('n', 'gti', vim.lsp.buf.implementation, vim.tbl_extend('force', bufopts, { desc = 'Go [T]o [I]mplementation' }))
        -- Go and Show
        vim.keymap.set('n', '<leader>dsc', '<cmd>Lspsaga show_cursor_diagnostics<CR>', bufopts)
        --
        vim.keymap.set(
          'n',
          '<leader>dw',
          '<cmd>Lspsaga show_workspace_diagnostics<CR>',
          vim.tbl_extend('force', bufopts, { desc = 'Show Workspace Diagnostics' })
        )
        -- Go and Do
        vim.keymap.set('n', 'gdr', '<cmd>Lspsaga rename<CR>', vim.tbl_extend('force', bufopts, { desc = '[D]o [R]ename' }))
        vim.keymap.set('n', 'gda', '<cmd>Lspsaga code_action<CR>', vim.tbl_extend('force', bufopts, { desc = '[D]o [A]ction' }))

        vim.keymap.set('n', '[d', '<cmd>Lspsaga diagnostic_jump_prev<CR>', bufopts)
        vim.keymap.set('n', ']d', '<cmd>Lspsaga diagnostic_jump_next<CR>', bufopts)

        vim.keymap.set('n', 'gtr', '<cmd>Lspsaga lsp_finder<CR>', vim.tbl_extend('force', bufopts, { desc = 'Go [T]o [R]eferences' }))
        vim.keymap.set('n', 'gdh', '<cmd>Lspsaga hover_doc<CR>', vim.tbl_extend('force', bufopts, { desc = '[D]o [H]over' }))
        vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, bufopts)
        -- Inside on_attach(client, bufnr)
        vim.keymap.set('n', 'K', '<cmd>Lspsaga signature_help<CR>', vim.tbl_extend('force', bufopts, { desc = 'Signature [H]elp' }))
        vim.keymap.set('n', 'gpd', '<cmd>Lspsaga preview_definition<CR>', vim.tbl_extend('force', bufopts, { desc = '[G]o [P]review Definition' }))
        vim.keymap.set('n', '<leader>dl', '<cmd>Lspsaga show_line_diagnostics<CR>', vim.tbl_extend('force', bufopts, { desc = 'Show Line Diagnostics' }))
        -- vim.keymap.set('n', '<leader>o', '<cmd>Lspsaga outline<CR>', vim.tbl_extend('force', bufopts, { desc = 'Toggle [O]utline' }))
        -- For insert-mode signature help:
        vim.keymap.set('i', '<C-k>', '<cmd>Lspsaga signature_help<CR>', { buffer = bufnr, desc = 'Signature Help' })
      end
      -- Global config for all servers
      vim.lsp.config('*', {
        capabilities = capabilities,
        on_attach = on_attach,
      })
      -- Server-specific overrides
      vim.lsp.config('lua_ls', {
        settings = {
          Lua = {
            runtime = { version = 'LuaJIT' },
            diagnostics = { globals = { 'vim' } },
            workspace = {
              library = vim.api.nvim_get_runtime_file('', true),
              checkThirdParty = false,
            },
            telemetry = { enable = false },
          },
        },
      })
      vim.lsp.config('basedpyright', {
        capabilities = capabilities,
        settings = {
          basedpyright = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = 'workspace',
              diagnosticSeverityOverrides = {
                reportUnknownArgumentType = 'none',
                reportUnknownParameterType = 'none',
                reportUnknownVariableType = 'none',
              },
              typeCheckingMode = 'standard',
              useLibraryCodeForTypes = true,
              extraPaths = {
                '/home/v/Code/work/forecast-store-product-feature-table-pipeline/__pypackages__/3.11/lib',
                '/home/v/Code/work/dagster-common',
              },
            },
          },
        },
      })
      -- Explicit config for Ruff to suppress "config not found" warning (uses global on_attach/capabilities)
      vim.lsp.config('ruff', {
        capabilities = capabilities, -- Explicitly pass for consistency
        on_attach = function(client, bufnr)
          on_attach(client, bufnr) -- Call your global on_attach for keymaps/etc.
          -- Disable overlaps: Let BasedPyright handle hovers (but *enable* code actions for fixes/imports)
          client.server_capabilities.hoverProvider = false
          -- Removed: client.server_capabilities.codeActionProvider = false
          -- Auto-fix lint issues (incl. import sorting) on save
          vim.api.nvim_create_autocmd('BufWritePre', {
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.code_action {
                context = {
                  only = { 'source.fixAll.ruff' },
                },
                apply = true,
              }
              -- Optional: Force sync format after fixes (helps with any async timing)
              vim.lsp.buf.format { async = false }
            end,
          })
        end,
        settings = {
          lint = {
            enable = true, -- Explicit: Ensure linting is on (default, but clear)
          },
          format = {
            enable = true, -- Explicit: Keep Ruff as the formatter
          },
        },
      })
      -- Diagnostic customizations
      vim.diagnostic.config {
        virtual_text = true,
        signs = true,
        update_in_insert = false,
        underline = true,
        severity_sort = true,
        float = { border = 'rounded' },
      }
    end,
  },
}
