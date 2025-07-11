-- local map = vim.api.nvim_set_keymap
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

vim.g.mapleader = ' '

-- Close buffer
map('n', '<leader>x', ':bd<CR>', opts)

-- Copy/paste to/from system clipboard
map('v', '<leader>y', '"+y', opts)
map('v', '<leader>Y', '"+Y', opts)
map('v', '<leader>p', '"+p', opts)
map('v', '<leader>P', '"+P', opts)

-- Moving highlighted text around
map('v', 'J', ":m '>+1<CR>gv=gv", opts)
map('v', 'K', ":m '<-2<CR>gv=gv", opts)

-- Fast comment / uncomment
map('v', '#', ':Commentary<CR>', opts)

-- Keep selection after indentation
map('v', '<', '<gv', opts)
map('v', '>', '>gv', opts)

map('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic message' })
