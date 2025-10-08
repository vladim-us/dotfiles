return {
  'romgrk/barbar.nvim',
  dependencies = {
    'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
    'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
  },
  init = function()
    vim.g.barbar_auto_setup = true
  end,
  opts = {
    -- Enable/disable animations
    animation = true,
    -- Automatically hide the tabline when there are this many buffers left.
    auto_hide = false,
    -- Enable/disable current/total tabpages indicator (top right corner)
    tabpages = true,
    -- Enables/disable clickable tabs
    clickable = true,
    -- Excludes buffers from the tabline
    exclude_ft = { 'javascript' },
    exclude_name = { 'package.json' },
    -- A buffer to this direction will be focused (if it exists) when closing the current buffer.
    focus_on_close = 'left',
    -- Hide inactive buffers and file extensions. Other options are `alternate`, `current`, and `visible`.
    hide = { extensions = true, inactive = true },
    -- Disable highlighting alternate buffers
    highlight_alternate = false,
    -- Disable highlighting file icons in inactive buffers
    highlight_inactive_file_icons = false,
    -- Enable highlighting visible buffers
    highlight_visible = true,
    icons = {
      -- Configure the base icons on the bufferline.
      buffer_index = false,
      buffer_number = false,
      button = '',
      -- Enables / disables diagnostic symbols
      diagnostics = {
        [vim.diagnostic.severity.ERROR] = { enabled = true, icon = 'ﬀ' },
        [vim.diagnostic.severity.WARN] = { enabled = false },
        [vim.diagnostic.severity.INFO] = { enabled = false },
        [vim.diagnostic.severity.HINT] = { enabled = true },
      },
      gitsigns = {
        added = { enabled = true, icon = '+' },
        changed = { enabled = true, icon = '~' },
        deleted = { enabled = true, icon = '-' },
      },
      filetype = {
        -- Sets the icon's highlight group.
        -- If false, will use nvim-web-devicons colors
        custom_colors = false,
        -- Requires `nvim-web-devicons` if `true`
        enabled = true,
      },
      separator = { left = '▎', right = '' },
      -- If true, add an additional separator at the end of the buffer list
      separator_at_end = true,
      -- Configure the icons on the bufferline when modified or pinned.
      modified = { button = '●' },
      pinned = { button = '', filename = true },
      -- Use a preconfigured buffer appearance— can be 'default', 'powerline', or 'slanted'
      preset = 'default',
      -- Configure the icons on the bufferline based on the visibility of a buffer.
      alternate = { filetype = { enabled = false } },
      current = { buffer_index = true },
      inactive = { button = '×' },
      visible = { modified = { buffer_number = false } },
    },
  },
  version = '^1.0.0', -- optional: only update when a new 1.x version is released

  config = function()
    local map = vim.keymap.set
    local opts = { noremap = true, silent = true }
    -- Move to previous/next
    map('n', '<A-,>', '<Cmd>BufferPrevious<CR>', opts)
    map('n', '<A-.>', '<Cmd>BufferNext<CR>', opts)

    -- Re-order to previous/next
    map('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', opts)
    map('n', '<A->>', '<Cmd>BufferMoveNext<CR>', opts)

    -- Go buffer in position...
    map('n', '<A-1>', '<Cmd>BufferGoto 1<CR>', opts)
    map('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', opts)
    map('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', opts)
    map('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', opts)
    map('n', '<A-5>', '<Cmd>BufferGoto 5<CR>', opts)
    map('n', '<A-6>', '<Cmd>BufferGoto 6<CR>', opts)
    map('n', '<A-7>', '<Cmd>BufferGoto 7<CR>', opts)
    map('n', '<A-8>', '<Cmd>BufferGoto 8<CR>', opts)
    map('n', '<A-9>', '<Cmd>BufferGoto 9<CR>', opts)
    map('n', '<A-0>', '<Cmd>BufferLast<CR>', opts)

    -- Pin/unpin buffer
    map('n', '<A-p>', '<Cmd>BufferPin<CR>', opts)

    -- Goto pinned/unpinned buffer
    --                 :BufferGotoPinned
    --                 :BufferGotoUnpinned

    -- Close buffer
    map('n', '<A-c>', '<Cmd>BufferClose<CR>', opts)

    -- Wipeout buffer
    --                 :BufferWipeout

    -- Close commands
    --                 :BufferCloseAllButCurrent
    --                 :BufferCloseAllButPinned
    --                 :BufferCloseAllButCurrentOrPinned
    --                 :BufferCloseBuffersLeft
    --                 :BufferCloseBuffersRight

    -- Magic buffer-picking mode
    -- map('n', '<C-p>', '<Cmd>BufferPick<CR>', opts)
    -- map('n', '<C-s-p>', '<Cmd>BufferPickDelete<CR>', opts)

    -- Sort automatically by...
    -- map('n', '<Space>bb', '<Cmd>BufferOrderByBufferNumber<CR>', opts)
    -- map('n', '<Space>bn', '<Cmd>BufferOrderByName<CR>', opts)
    -- map('n', '<Space>bd', '<Cmd>BufferOrderByDirectory<CR>', opts)
    -- map('n', '<Space>bl', '<Cmd>BufferOrderByLanguage<CR>', opts)
    -- map('n', '<Space>bw', '<Cmd>BufferOrderByWindowNumber<CR>', opts)
  end,
}
