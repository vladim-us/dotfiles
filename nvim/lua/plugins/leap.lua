return {
  'ggandor/leap.nvim',
  event = 'VeryLazy',
  config = function()
    local leap = require 'leap'
    -- Explicit mappings instead of defaults
    vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap)')
    vim.keymap.set('n', 'S', '<Plug>(leap-from-window)')
    -- Optional: Customize leap settings here
    -- For example:
    -- vim.g.leap_nojump = 1  -- Disable autojump
    -- leap.opts.safe_labels = { 's', 'f', 'n', 'j', 'k', 'l', 'h', 'd', 't', 'w', 'z', 'v', 'b', 'm', 'q', 'u', 'e', 'c', 'x', 'o', 'r', 'p', 'i', 'a' }
  end,
}
