return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",  -- LSP source
      "hrsh7th/cmp-buffer",    -- Buffer source
      "hrsh7th/cmp-path",      -- Path source
      "L3MON4D3/LuaSnip",      -- Snippet engine
      "saadparwaiz1/cmp_luasnip", -- Snippet source
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      })

      -- Link CMP to LSP capabilities
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      require("lspconfig").pyright.setup({ capabilities = capabilities })
      require("lspconfig").rust_analyzer.setup({ capabilities = capabilities })
      require("lspconfig").lua_ls.setup({ capabilities = capabilities })
    end,
  },
}
