return {

  {
    'MagicDuck/grug-far.nvim',
    -- Note (lazy loading): grug-far.lua defers all it's requires so it's lazy by default
    -- additional lazy config to defer loading is not really needed...
    config = function()
      -- optional setup call to override plugin options
      -- alternatively you can set options with vim.g.grug_far = { ... }
      require('grug-far').setup {
        -- options, see Configuration section below
        -- there are no required options atm
      }
    end,
  },

  {
    'aznhe21/actions-preview.nvim',
    dependencies = { 'MunifTanjim/nui.nvim' },
    config = function()
      local ap = require 'actions-preview'
      ap.setup {
        -- Default configuration (customize as needed):
        diff = {
          ctxlen = 3, -- Context lines for vim.diff()
        },
        highlight_command = {
          -- Optional: Add external diff highlighters (e.g., delta)
          -- require("actions-preview.highlight").delta(),
        },
        backend = { 'nui', 'minipick', 'snacks' }, -- Preferred backends (telescope is default)
        nui = { -- Options for nui backend (if used)
          dir = 'col',
          keymap = nil,
          layout = {
            position = '50%',
            size = {
              width = '60%',
              height = '90%',
            },
            min_width = 40,
            min_height = 10,
            relative = 'editor',
          },
          preview = {
            size = '60%',
            border = {
              style = 'rounded',
              padding = { 0, 1 },
            },
          },
          select = {
            size = '40%',
            border = {
              style = 'rounded',
              padding = { 0, 1 },
            },
          },
        },
        snacks = {
          layout = { preset = 'default' },
        },
      }
      -- Example keymap: Bind to 'gf' in normal/visual mode to preview code actions
      vim.keymap.set({ 'n', 'v' }, 'gf', ap.code_actions)
    end,
  },
}
