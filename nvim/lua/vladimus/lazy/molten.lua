return {
  {
    "benlubas/molten-nvim",
    version = "^1.0.0", -- use the 1.x branch
    dependencies = {
      "3rd/image.nvim", -- optional, for image.nvim as image provider
    },
    build = ":UpdateRemotePlugins",
    init = function()
      -- these are examples; set only what you need
      -- see :help molten-nvim-configuration for all options
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_output_win_max_height = 0.6
      vim.g.molten_auto_open_output = false
      vim.g.molten_wrap_output = true
      vim.g.molten_virt_text_output = true
      vim.g.molten_virt_lines_off_by_1 = true
      vim.g.molten_virt_text_max_lines = 12
    end,
    keys = {
      { "<localleader>mi", ":MoltenInit<CR>", desc = "Initialize Molten", mode = "n" },
      { "<localleader>mv", ":MoltenEvaluateVisual<CR>", desc = "Evaluate visual selection", mode = "v" },
      { "<localleader>rr", ":MoltenEvaluateOperator<CR>", desc = "Run operator selection", mode = "n" },
      { "<localleader>rl", ":MoltenEvaluateLine<CR>", desc = "Evaluate line", mode = "n" },
      { "<localleader>rc", ":MoltenReevaluateCell<CR>", desc = "Re-evaluate cell", mode = "n" },
      { "<localleader>rC", ":MoltenReevaluateAll<CR>", desc = "Re-evaluate all cells", mode = "n" },
    },
  },
  {
    -- optional, for image rendering via image.nvim (pick one provider)
    "3rd/image.nvim",
    opts = {
      backend = "kitty", -- or "ueberzug" if preferred
      max_width = 100,
      max_height = 12,
      max_height_window_percentage = math.huge,
      max_width_window_percentage = math.huge,
      window_overlap_clear_enabled = true,
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    },
  },
}
