return {
  {
    'smjonas/live-command.nvim',
    enabled = false,
    -- live-command supports semantic versioning via Git tags
    -- tag = "2.*",
    config = function()
      require('live-command').setup()
    end,
  },
  {
    'kkoomen/vim-doge',
    enabled = false,
  },
}
