return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x", -- Use the stable 3.x branch
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "nvim-tree/nvim-web-devicons", -- Optional, for file icons
    },
    config = function()
        require("neo-tree").setup({
            -- Basic configuration (customize as needed)
            sources = { "filesystem", "buffers", "git_status" },
            filesystem = {
                follow_current_file = { enabled = true }, -- Auto-focus current file
                use_libuv_file_watcher = true, -- Auto-refresh on file changes
                window = {
                    mappings = {
                        ["o"] = "system_open"},
                },

            },
            commands = {
                system_open = function(state)
                    local node = state.tree:get_node()
                    local path = node:get_id()
                    -- macOs: open file in default application in the background.
                    vim.fn.jobstart({ "open", path }, { detach = true })
                    -- Linux: open file in default application
                    vim.fn.jobstart({ "xdg-open", path }, { detach = true })

                    -- Windows: Without removing the file from the path, it opens in code.exe instead of explorer.exe
                    local p
                    local lastSlashIndex = path:match("^.+()\\[^\\]*$") -- Match the last slash and everything before it
                    if lastSlashIndex then
                        p = path:sub(1, lastSlashIndex - 1) -- Extract substring before the last slash
                    else
                        p = path -- If no slash found, return original path
                    end
                    vim.cmd("silent !start explorer " .. p)
                end,
            },
            window = {
                mappings = {
                    ["<space>"] = "none", -- Disable space to avoid conflicts
                    ["l"] = "open",
                    ["h"] = "close_node",
                },
                width = "100%", -- Full width
                height = "100%", -- Full height
            },
        })

        -- Autocommand to open Neo-tree on startup
        vim.api.nvim_create_autocmd("VimEnter", {
            callback = function()
                vim.cmd("Neotree toggle")
            end,
        })
    end,
    keys = {
        { "<leader>fe", "<cmd>Neotree toggle<cr>", desc = "Toggle NeoTree" },
    },
}
