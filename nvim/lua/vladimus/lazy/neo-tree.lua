return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons", -- optional, but recommended for icons
    },
    lazy = false, -- neo-tree will lazily load itself
    ---@module 'neo-tree'
    ---@type neotree.Config
    opts = {
      filesystem = {
        follow_current_file = { enabled = true },
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
        },
        hijack_netrw_behavior = "open_current",
      },
      popup_border_style = "single",
      -- Add renderer settings for trailing slashes and highlights
      renderer = {
        add_trailing = true, -- Add trailing slash to directories
        group_empty = true, -- Optional: Groups empty directories
        highlight_git = true, -- Optional: Enable git status highlights
        highlight_opened_files = "all", -- Highlight open files
      },
      -- Custom highlights for directories and files
      window = {
        mappings = {}, -- Add custom keymappings if needed
      },
      -- Define highlight groups
      event_handlers = {
        {
          event = "neo_tree_buffer_enter",
          handler = function()
            -- Enable line numbers in neo-tree buffer
            vim.wo.number = true
            -- Set highlights for directories and files
            vim.api.nvim_set_hl(0, "NeoTreeDirectoryName", { fg = "#7aa2f7", bold = true }) -- Blue from TokyoNight for directories
            vim.api.nvim_set_hl(0, "NeoTreeFileName", { fg = "#9ece6a" }) -- Green from TokyoNight for files
            vim.api.nvim_set_hl(0, "NeoTreeGitModified", { fg = "#f7768e" }) -- Red for modified files (optional)
            vim.api.nvim_set_hl(0, "NeoTreeGitStaged", { fg = "#bb9af7" }) -- Purple for staged files (optional)
          end,
        },
      },
    },
  },
}
