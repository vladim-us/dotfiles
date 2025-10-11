return {
  -- Autocompletion
  'saghen/blink.cmp',
  event = 'VimEnter',
  version = '1.*',
  dependencies = {
    -- Snippet Engine
    {
      'L3MON4D3/LuaSnip',
      version = '2.*',
      build = (function()
        -- Build Step is needed for regex support in snippets.
        -- This step is not supported in many windows environments.
        -- Remove the below condition to re-enable on windows.
        if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
          return
        end
        return 'make install_jsregexp'
      end)(),
      dependencies = { 'rafamadriz/friendly-snippets' },
      opts = {},
    },
    -- Codeium (Windsurf) integration
    {
      'Exafunction/windsurf.nvim',
      dependencies = {
        'nvim-lua/plenary.nvim',
      },
      config = function()
        require('codeium').setup {}
      end,
    },
  },
  --- @module 'blink.cmp'
  --- @type blink.cmp.Config
  opts = {
    keymap = {
      preset = 'default',
    },
    appearance = {
      nerd_font_variant = 'mono',
    },
    completion = {
      documentation = { auto_show = false, auto_show_delay_ms = 500 },
    },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer', 'codeium' },
      providers = {
        codeium = { name = 'Codeium', module = 'codeium.blink', async = true }, -- Added provider config
      },
    },
    snippets = { preset = 'luasnip' },
    fuzzy = { implementation = 'prefer_rust' },
    -- Shows a signature help window while you type arguments for a function
    signature = { enabled = true },
  },
}
