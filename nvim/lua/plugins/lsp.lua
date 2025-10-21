return {
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
      lightbulb = { enable = true },
      symbol_in_winbar = { enable = true },
    },
    config = function(_, opts)
      require('lspsaga').setup(opts)
    end,
  },
  {
    'mason-org/mason-lspconfig.nvim',
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      'neovim/nvim-lspconfig',
      'saghen/blink.cmp',
    },
    config = function()
      local lspconfig = require 'lspconfig'
      local capabilities = vim.tbl_deep_extend('force', vim.lsp.protocol.make_client_capabilities(), require('blink.cmp').get_lsp_capabilities())

      local on_attach = function(client, bufnr)
        local bufopts = { buffer = bufnr, noremap = true, silent = true }
        vim.keymap.set('n', 'gd', '<cmd>Lspsaga goto_definition<CR>', vim.tbl_extend('force', bufopts, { desc = 'Goto Definition' }))
        vim.keymap.set('n', 'gD', '<cmd>Lspsaga goto_declaration<CR>', vim.tbl_extend('force', bufopts, { desc = 'Goto Declaration' }))
        vim.keymap.set('n', 'gt', '<cmd>Lspsaga goto_type_definition<CR>', vim.tbl_extend('force', bufopts, { desc = 'Goto Type Definition' }))
        vim.keymap.set('n', 'gi', '<cmd>Lspsaga finder imp<CR>', vim.tbl_extend('force', bufopts, { desc = 'Goto Implementation' }))
        vim.keymap.set('n', 'gr', '<cmd>Lspsaga finder ref<CR>', vim.tbl_extend('force', bufopts, { desc = 'Goto References' }))
        vim.keymap.set({ 'n', 'v' }, '<leader>ca', '<cmd>Lspsaga code_action<CR>', vim.tbl_extend('force', bufopts, { desc = 'Code Action' }))

        vim.keymap.set('n', '<leader>rnn', '<cmd>Lspsaga rename<CR>', vim.tbl_extend('force', bufopts, { desc = 'Rename' }))
        vim.keymap.set('n', 'gp', '<cmd>Lspsaga peek_definition<CR>', vim.tbl_extend('force', bufopts, { desc = 'Peek Definition' }))

        vim.keymap.set('n', '<leader>[d', '<cmd>Lspsaga diagnostic_jump_prev<CR>', bufopts)
        vim.keymap.set('n', '<leader>]d', '<cmd>Lspsaga diagnostic_jump_next<CR>', bufopts)

        vim.keymap.set('i', '<C-k>', '<cmd>Lspsaga signature_help<CR>', { buffer = bufnr, desc = 'Signature Help' })
        vim.keymap.set('n', 'K', '<cmd>Lspsaga hover_doc<CR>', vim.tbl_extend('force', bufopts, { desc = 'Hover Documentation' }))

        -- vim.keymap.set('n', '<leader>gsc', '<cmd>Lspsaga show_cursor_diagnostics<CR>', bufopts)
        -- vim.keymap.set('n', '<leader>gpd', '<cmd>Lspsaga preview_definition<CR>', vim.tbl_extend('force', bufopts, { desc = '[G]o [P]review Definition' }))
        --
        -- vim.keymap.set('n', '<leader>gdl', '<cmd>Lspsaga show_line_diagnostics<CR>', vim.tbl_extend('force', bufopts, { desc = 'Show Line Diagnostics' }))
        -- vim.keymap.set('n', '<leader>lo', '<cmd>Lspsaga outline<CR>', vim.tbl_extend('force', bufopts, { desc = 'Toggle [O]utline' }))
        -- For insert-mode signature help:

        -- Enable inlay hints
        if vim.lsp.inlay_hint then
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end
        -- Bonus keymap for toggling inlay hints
        vim.keymap.set('n', '<leader>lih', function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr })
        end, { buffer = bufnr, desc = 'Toggle [I]nlay [H]ints' })
      end

      vim.fn.sign_define('DiagnosticSignError', { text = '', texthl = 'DiagnosticSignError' })
      vim.fn.sign_define('DiagnosticSignWarn', { text = '', texthl = 'DiagnosticSignWarn' })
      vim.fn.sign_define('DiagnosticSignInfo', { text = '', texthl = 'DiagnosticSignInfo' })
      vim.fn.sign_define('DiagnosticSignHint', { text = '󰌵', texthl = 'DiagnosticSignHint' })

      vim.diagnostic.config {
        virtual_text = {
          prefix = '● ',
          spacing = 4,
        },
        signs = true,
        update_in_insert = false,
        underline = true,
        severity_sort = true,
        float = { border = 'rounded' },
      }

      require('mason-lspconfig').setup {
        ensure_installed = {
          'lua_ls',
          'rust_analyzer',
          'ruff',
          'basedpyright',
        },
        automatic_enable = true,
        handlers = {
          function(server_name)
            print('Default handler for: ' .. server_name)
            lspconfig[server_name].setup {
              capabilities = capabilities,
              on_attach = on_attach,
            }
          end,

          ['lua_ls'] = function()
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
          end,

          ['basedpyright'] = function()
            lspconfig.basedpyright.setup {
              capabilities = capabilities,
              on_attach = on_attach,
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
                      -- '/home/v/Code/work/forecast-store-product-feature-table-pipeline/__pypackages__/3.11/lib',
                      -- '/home/v/Code/work/dagster-common',
                    },
                  },
                },
              },
            }
          end,

          -- ['ty'] = function()
          --   lspconfig.ty.setup {
          --     capabilities = capabilities,
          --     on_attach = on_attach,
          --     settings = {
          --       python = {
          --         analysis = {
          --           autoSearchPaths = true,
          --           diagnosticMode = 'workspace',
          --           typeCheckingMode = 'standard',
          --           useLibraryCodeForTypes = true,
          --         },
          --       },
          --     },
          --   }
          -- end,
          --
          ['ruff'] = function()
            lspconfig.ruff.setup {
              capabilities = capabilities,
              on_attach = function(client, bufnr)
                on_attach(client, bufnr)
                client.server_capabilities.hoverProvider = false
                client.server_capabilities.documentFormattingProvider = false -- Let Conform handle all formatting
              end,
              settings = {
                lint = { enable = true },
                format = { enable = true },
              },
            }
          end,
        },
      }
    end,
  },
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' }, -- Lazy-load on save
    opts = {
      formatters_by_ft = {
        lua = { 'stylua' }, -- Replaces none-ls stylua
        python = { 'ruff_fix', 'ruff_format' }, -- Run fixes first, then format
        rust = { 'rustfmt' }, -- CLI fallback to rust_analyzer
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true, -- Uses Ruff LSP if no CLI formatter
      },
      default_format_opts = { lsp_fallback = true },
    },
  },
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'mason-org/mason.nvim',
      'mason-org/mason-lspconfig.nvim',
      'saghen/blink.cmp', -- For capabilities, since you use blink.cmp
      'nvimdev/lspsaga.nvim',
    },
  },
}
