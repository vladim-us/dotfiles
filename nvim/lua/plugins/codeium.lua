return {
  'Exafunction/windsurf.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = function()
    require('codeium').setup {
      enable_cmp_source = false, -- Disable default cmp source since we're using blink.cmp
      virtual_text = {
        enabled = true, -- Enable inline (ghost text) suggestions
        manual = false, -- Auto-trigger on idle
        idle_delay = 75, -- ms delay after typing stops
        key_bindings = {
          accept = '<Tab>', -- Accept full suggestion
          accept_word = '<C-l>', -- Accept next word only
          accept_line = '<C-j>', -- Accept next line only
          next = '<M-]>', -- Cycle next
          prev = '<M-[>', -- Cycle previous
        },
      },
      -- Optional: Enterprise mode (if applicable)
      -- enterprise_mode = true,
      -- api = {
      --   host = "codeium.example.com",
      --   port = 443,
      -- },
    }
  end,
}
