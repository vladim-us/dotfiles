return {
  "tpope/vim-fugitive",
  config = function()
    -- Optional keymaps for common commands
    vim.keymap.set("n", "<leader>gb", ":Git branch<CR>", { desc = "Git branch" })
    vim.keymap.set("n", "<leader>gcam", ":Git commit -am<CR>", { desc = "Git add all and commit" })
    vim.keymap.set("n", "<leader>ga", ":Git add<CR>", { desc = "Git add" })
    vim.keymap.set("n", "<leader>gcb", ":Git checkout -b<CR>", { desc = "Git checkout -b" })
    vim.keymap.set("n", "<leader>gps", ":Git push<CR>", { desc = "Git push" })
    vim.keymap.set("n", "<leader>gpsf", ":Git push --force<CR>", { desc = "Git push force" })
    vim.keymap.set("n", "<leader>gpl", ":Git pull<CR>", { desc = "Git pull" })
    vim.keymap.set("n", "<leader>gdf", ":Gdiffsplit<CR>", { desc = "Git diff" })
  end,
}
