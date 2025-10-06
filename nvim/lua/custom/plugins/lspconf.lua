-- lua/plugins/lsp.lua
-- LSP and related plugin configurations

return {
  -- Mason: Tool installer for LSP servers, linters, and formatters
  {
    'mason-org/mason.nvim',
    cmd = { 'Mason', 'MasonInstall', 'MasonUninstall', 'MasonUninstallAll', 'MasonLog' },
    opts = {
      ensure_installed = {
        'lua-language-server', -- For Lua LSP
        'basedpyright', -- For Python LSP
        'rust-analyzer', -- For Rust LSP
        'ruff', -- For Python formatting and linting
      },
      PATH = 'prepend', -- How to add installed tools to PATH
      ui = {
        icons = {
          package_installed = '✓',
          package_pending = '➜',
          package_uninstalled = '✗',
        },
      },
    },
  },

  -- Mason-LSPConfig: Bridges Mason and nvim-lspconfig
  {
    'mason-org/mason-lspconfig.nvim',
    dependencies = { 'mason-org/mason.nvim' },
    opts = {
      ensure_installed = {
        'lua_ls',
        'basedpyright',
        'rust_analyzer',
      },
      automatic_installation = true, -- Auto-install servers configured in lspconfig
    },
  },

  -- Mason-Null-LS: Bridges Mason and none-ls (for linters/formatters)
  {
    'jay-babu/mason-null-ls.nvim',
    dependencies = { 'mason-org/mason.nvim', 'nvimtools/none-ls.nvim' },
    opts = {
      ensure_installed = {
        'ruff', -- Python formatter and linter
      },
      automatic_installation = true,
    },
  },

  -- None-LS: Provides LSP features for non-LSP tools (linters, formatters, etc.)
  {
    'nvimtools/none-ls.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'jay-babu/mason-null-ls.nvim',
    },
    opts = function()
      local null_ls = require 'null-ls'
      return {
        sources = {
          null_ls.builtins.formatting.ruff,
          null_ls.builtins.diagnostics.ruff, -- Include diagnostics for completeness
        },
        on_attach = function(client, bufnr)
          -- Auto-format on save
          if client.supports_method 'textDocument/formatting' then
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format { bufnr = bufnr }
              end,
            })
          end
        end,
      }
    end,
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
        local opts = { buffer = bufnr, noremap = true, silent = true }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set('n', '<leader>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
        vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
        vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)

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
      end

      -- Server setups (manually instead of setup_handlers)
      local lspconfig = require 'lspconfig'

      lspconfig.lua_ls.setup {
        capabilities = capabilities,
        on_attach = on_attach,
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
      }

      lspconfig.basedpyright.setup {
        capabilities = capabilities,
        on_attach = on_attach,
      }

      lspconfig.rust_analyzer.setup {
        capabilities = capabilities,
        on_attach = on_attach,
      }

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
      local signs = { Error = '󰅚 ', Warn = '󰀪 ', Hint = '󰌶 ', Info = ' ' }
      for type, icon in pairs(signs) do
        local hl = 'DiagnosticSign' .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end
    end,
  },
}
