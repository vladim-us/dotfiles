-- Tokyonight colorscheme configuration for Neovim
return {
    {
        "folke/tokyonight.nvim",
        lazy = false, -- Load the plugin immediately
        priority = 1000, -- Ensure it loads before other plugins
        config = function()
            require("tokyonight").setup({
                style = "moon", -- Theme style: storm, moon, night, or day
                transparent = true, -- Disable background color
                terminal_colors = true, -- Apply colors to Neovim's :terminal
                styles = {
                    comments = { italic = false }, -- Disable italic comments
                    keywords = { italic = false }, -- Disable italic keywords
                    sidebars = "dark", -- Dark style for sidebars
                    floats = "dark", -- Dark style for floating windows
                },
            })
            -- Apply the colorscheme
            vim.cmd([[colorscheme tokyonight]])
        end,
    }
}
