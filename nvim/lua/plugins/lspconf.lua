-- LSP and related plugin configurations
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
          'ruff', -- Add for Ruff LSP (handles Python linting/formatting)
        },
        automatic_enable = true, -- Auto-enables installed servers
      }
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
    },
    config = function()
      -- Setup capabilities (integrate with blink.cmp)
      local capabilities = vim.tbl_deep_extend('force', vim.lsp.protocol.make_client_capabilities(), require('blink.cmp').get_lsp_capabilities())
      -- Global on_attach function
      local on_attach = function(client, bufnr)
        -- Keymaps
        local bufopts = { buffer = bufnr, noremap = true, silent = true }
        vim.keymap.set('n', 'gtd', vim.lsp.buf.definition, vim.tbl_extend('force', bufopts, { desc = 'Go [T]o Definition' }))
        vim.keymap.set('n', 'gtD', vim.lsp.buf.declaration, vim.tbl_extend('force', bufopts, { desc = 'Go [T]o [D]eclaration' }))
        vim.keymap.set('n', 'gti', vim.lsp.buf.implementation, vim.tbl_extend('force', bufopts, { desc = 'Go [T]o [I]mplementation' }))
        vim.keymap.set('n', 'gtr', vim.lsp.buf.references, vim.tbl_extend('force', bufopts, { desc = 'Go [T]o [R]eferences' }))
        vim.keymap.set('n', 'gtt', vim.lsp.buf.type_definition, vim.tbl_extend('force', bufopts, { desc = 'Go [T]o [T]ype definition' }))
        vim.keymap.set('n', 'gh', vim.lsp.buf.hover, vim.tbl_extend('force', bufopts, { desc = 'Code [H]over' }))
        vim.keymap.set('n', 'gr', vim.lsp.buf.rename, vim.tbl_extend('force', bufopts, { desc = 'Code [R]ename' }))
        vim.keymap.set('n', 'ga', vim.lsp.buf.code_action, vim.tbl_extend('force', bufopts, { desc = 'Code [A]ction' }))

        -- vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
        -- vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
        -- vim.keymap.set('n', '<leader>wl', function()
        --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        -- end, opts)
        -- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
        -- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
        -- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
        -- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)
        -- Highlight references (if illuminate is not handling it)
        if client.supports_method 'textDocument/documentHighlight' then
          vim.api.nvim_create_augroup('lsp_document_highlight', { clear = false })
          vim.api.nvim_clear_autocmds { buffer = bufnr, group = 'lsp_document_highlight' }
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            callback = vim.lsp.buf.document_highlight,
            buffer = bufnr,
            group = 'lsp_document_highlight',
          })
          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            callback = vim.lsp.buf.clear_references,
            buffer = bufnr,
            group = 'lsp_document_highlight',
          })
        end
        -- Removed auto-format on save: Handled by conform.nvim
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
      -- Custom signs for diagnostics
      -- local signs = { Error = '󰅚 ', Warn = '󰀪 ', Hint = '󰌶 ', Info = ' ' }
      -- for type, icon in pairs(signs) do
      --   local hl = 'DiagnosticSign' .. type
      --   vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      -- end
    end,
  },
}
