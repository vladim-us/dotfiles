return {
  {
    'aznhe21/actions-preview.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' }, -- Required for the default backend
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
        backend = { 'nui', 'telescipe', 'minipick', 'snacks' }, -- Preferred backends (telescope is default)
        telescope = vim.tbl_extend('force', require('telescope.themes').get_dropdown {}, {
          -- Customize telescope display if needed
          make_value = nil,
          make_make_display = nil,
        }),
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
