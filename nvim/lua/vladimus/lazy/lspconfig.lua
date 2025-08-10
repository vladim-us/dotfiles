-- Minimal nvim-lspconfig setup for LazyVim with basedpyright, ruff, and rust_analyzer
return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lspconfig = require("lspconfig")
      -- Lua language server
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = { library = vim.api.nvim_get_runtime_file("", true) },
            telemetry = { enable = false },
          },
        },
      })
      -- Basedpyright for Python
      lspconfig.basedpyright.setup({
        settings = {
          basedpyright = {
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "openFilesOnly",
            },
          },
        },
      })
      -- Ruff for formatting
      lspconfig.ruff.setup({
        on_attach = function(client, bufnr)
          client.server_capabilities.documentFormattingProvider = true
          -- Optional: Keymap for formatting
          vim.api.nvim_buf_set_keymap(
            bufnr,
            "n",
            "<leader>f",
            "<cmd>lua vim.lsp.buf.format({ async = true })<CR>",
            { noremap = true, silent = true }
          )
        end,
      })
      -- Rust Analyzer for Rust
      lspconfig.rust_analyzer.setup({
        settings = {
          ["rust-analyzer"] = {
            check = {
              command = "clippy", -- Use clippy for checking
            },
            diagnostics = {
              enable = true,
            },
            files = {
              excludeDirs = { ".git", "target" },
            },
          },
        },
      })
    end,
  },
}
