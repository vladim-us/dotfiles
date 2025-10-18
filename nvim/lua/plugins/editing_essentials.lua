return {
  { 'NMAC427/guess-indent.nvim' },

  {
    'mg979/vim-visual-multi',
    enabled = false,
  },
  {
    'mbbill/undotree',

    config = function()
      vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
    end,
  },
  {
    'kylechui/nvim-surround',
    version = '^3.0.0', -- Use for stability; omit to use `main` branch for the latest features
    event = 'VeryLazy',
    config = function()
      require('nvim-surround').setup {
        -- Configuration here, or leave empty to use defaults
      }
    end,
  },
  {
    {
      'windwp/nvim-autopairs',
      event = 'InsertEnter',
      opts = {
        -- Default configuration (customize as needed):
        check_ts = true, -- Enable treesitter integration (requires nvim-treesitter)
        ts_config = {
          lua = { 'string', 'source' }, -- Treesitter nodes to ignore for Lua
          javascript = { 'string', 'template_string' }, -- Treesitter nodes to ignore for JavaScript
          java = false, -- Disable for Java (or set to specific nodes)
        },
        disable_filetype = { 'TelescopePrompt', 'spectre_panel' }, -- Filetypes to disable autopairs
        fast_wrap = {
          map = '<M-e>', -- Wrap to next line
          chars = { '{', '[', '(', '"', "'" }, -- Characters to wrap
          pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], '%s+', ''), -- Pattern for fast wrap
          offset = 0, -- Offset for fast wrap
          end_key = '$', -- End key for fast wrap
          keys = 'qwertyuiopzxcvbnmasdfghjkl', -- Keys for fast wrap
          check_comma = true, -- Check for comma after wrap
          highlight = 'PmenuSel', -- Highlight for fast wrap
          highlight_grey = 'LineNr', -- Highlight grey for fast wrap
        },
        ignored_next_char = string.gsub([=[[%w%%%'%[%"%.%]]]=], '%s+', ''), -- Characters to ignore next
        enable_check_bracket_line = true, -- Check bracket line
        disable_in_macro = false, -- Disable in macro mode
        ignored_next_char = [=[[%w%%%'%[%"%.]]=], -- Characters to ignore next
      },
      config = function(_, opts)
        require('nvim-autopairs').setup(opts)

        -- Optional: Add rules or integrations (e.g., with cmp for completion)
        local npairs = require 'nvim-autopairs'
        local Rule = require 'nvim-autopairs.rule'
        local cond = require 'nvim-autopairs.conds'

        -- Example custom rule: Auto-pair < > in HTML/JSX
        npairs.add_rules {
          Rule('<', '>', { 'html', 'javascriptreact', 'typescriptreact' }):with_pair(cond.not_inside_quote()):with_move(cond.none()),
        }

        -- Example integration with nvim-cmp (if using completion plugin)
        -- local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        -- local cmp = require("cmp")
        -- cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end,
    },
  },
}
