vim.opt.guicursor = ""

-- for the files
vim.opt.nu = true
vim.opt.relativenumber = true

-- for the file explorer
vim.opt_local.number = true
vim.opt_local.relativenumber = true


vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"
vim.wo.number = true
vim.g.netrw_liststyle = 1
vim.opt.clipboard = "unnamedplus"
-- then you need to set the option below.
vim.g.lazyvim_picker = "fzf"

vim.g.lazyvim_python_lsp = "basedpyright"

vim.g.lazyvim_python_ruff = "ruff"
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
