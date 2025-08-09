return {
  -- Mason: Manages installation of language servers
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({
        ui = {
          border = "rounded", -- Optional: Nicer UI border
        },
      })
    end,
  },

  -- Bridge between Mason and lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        -- Automatically install these servers via Mason
        ensure_installed = { "basedpyright", "rust_analyzer", "lua_ls" },
      })
    end,
  },

  -- Main LSP configuration plugin
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      local lspconfig = require("lspconfig")

      -- Global LSP keymaps (these apply after a language server attaches to a buffer)
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local opts = { buffer = ev.buf }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts) -- Go to definition
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts) -- Hover info
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts) -- Code actions
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- Rename symbol
          vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, opts) -- Find references
          vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts) -- Show diagnostics
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- Previous diagnostic
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- Next diagnostic
        end,
      })

      -- Server-specific setups
      lspconfig.basedpyright.setup({
        settings = {
          basedpyright = {
            -- Top-level settings (validated: booleans, defaults false)
            disableLanguageServices = false, -- Ensures all LSP features (hover, completions, etc.) are enabled
            disableOrganizeImports = false, -- Enables "Organize Imports" command
            disableTaggedHints = false, -- Enables tagged hints for unreachable/deprecated code

            analysis = {
              -- Analysis settings (validated from docs: enables full workspace analysis and all diagnostics/features)
              autoSearchPaths = true, -- Automatically detect common paths like "src" (type: boolean, default: false)
              useLibraryCodeForTypes = true, -- Analyze library code for better type inference (type: boolean, default: true)
              diagnosticMode = "workspace", -- Analyze all files in workspace, not just open ones (type: string, options: "openFilesOnly"/"workspace", default: "openFilesOnly")
              typeCheckingMode = "all", -- Enables ALL diagnostic rules, including Basedpyright-specific ones (type: string, options: "off"/"basic"/"standard"/"strict"/"recommended"/"all", default: "standard")
              autoImportCompletions = true, -- Offer auto-import suggestions in completions (type: boolean, default: false)
              logLevel = "Trace", -- Max verbosity for output panel logs (type: string, options: "Error"/"Warning"/"Information"/"Trace", default: "Information")

              -- Inlay hints (Pylance feature; validated: all enabled by default, but explicitly set for completeness)
              inlayHints = {
                variableTypes = true, -- Show types on variable assignments (type: boolean, default: true)
                callArgumentNames = true, -- Show parameter names in function calls (type: boolean, default: true)
                functionReturnTypes = true, -- Show return types on function defs (type: boolean, default: true)
              },
            },
          },
        },
      })

      -- Rust: Using rust_analyzer (handles Cargo integration, inlay hints, etc.)
      lspconfig.rust_analyzer.setup({
        settings = {
          ["rust-analyzer"] = {
            checkOnSave = {
              command = "clippy", -- Use clippy for checks
            },
          },
        },
      })

      -- Lua: Using lua_ls (handles Neovim runtime awareness)
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" }, -- Recognize vim globals
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true), -- Neovim runtime files
            },
            telemetry = {
              enable = false, -- Disable telemetry
            },
          },
        },
      })
    end,
  },
}
