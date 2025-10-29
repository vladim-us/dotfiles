return {
  {
    'kdheepak/lazygit.nvim',
    cmd = { 'LazyGit', 'LazyGitConfig', 'LazyGitCurrentFile', 'LazyGitFilter', 'LazyGitFilterCurrentFile' },
    -- optional for floating window border decoration
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      floating_window_winblend = 0, -- 0-100 transparency
      floating_window_scaling_factor = 0.9, -- Size as % of editor
      floating_window_border_chars = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' }, -- Pretty borders
      use_neovim_remote = true, -- Edit commits in Neovim (requires neovim-remote installed via pip)
    },
    keys = {
      { '<leader>gg', '<cmd>LazyGit<cr>', desc = 'LazyGit (root dir)' },
      { '<leader>gG', '<cmd>LazyGitCurrentFile<cr>', desc = 'LazyGit (current file)' },
    },
  },
  {
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
    opts = {
      view = { default = { layout = 'diff2_horizontal' } }, -- Default side-by-side
      hooks = {
        diff_buf_read = function(bufnr)
          vim.b[bufnr].view_activated = 1
        end,
      },
    },
    keys = {
      { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = 'Git Diff Overview' },
      { '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', desc = 'File History' },
      { '<leader>gm', '<cmd>DiffviewOpen MERGE_HEAD<cr>', desc = 'Merge Conflicts' },
    },
  },
  {
    'akinsho/git-conflict.nvim',
    version = '*',
    config = true,
  },
  {
    'f-person/git-blame.nvim',
    opts = { enabled = false, date_format = '%r' },
  },
  {
    'ruifm/gitlinker.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('gitlinker').setup()
    end,
    keys = { '<leader>gy' },
  },
}
