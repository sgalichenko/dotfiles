-- local map = vim.api.nvim_set_keymap
local map = vim.keymap.set
local opts = { noremap = true, silent = true }
local noremap = { noremap = false, silent = true }

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
map('v', '#', ":lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", noremap)

-- Keep selection after indentation
map('v', '<', '<gv', opts)
map('v', '>', '>gv', opts)

map('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Show diagnostic message' })

--- Tables
map('v', 't', ":! tr -s ' ' | column -t -s '|' -o '  |  '| sed 's/^[[:space:]]*//;s/[[:space:]]*$//'<CR>", opts)

--- Execute command
map('v', '<leader>e', ":y<CR>p0v$:!sh<CR>", opts)
map('n', '<leader>e', "0v$:y<CR>p0v$:!sh<CR>", opts)


-- In your main config or keymaps file
map('n', '<C-h>', '<C-w>h', { desc = 'Move to left split' })
map('n', '<C-l>', '<C-w>l', { desc = 'Move to right split' })
map('n', '<C-j>', '<C-w>j', { desc = 'Move to split below' })
map('n', '<C-k>', '<C-w>k', { desc = 'Move to split above' })
map('t', '<C-h>', '<C-\\><C-n><C-w>h', { desc = 'Move to left split from terminal' })
map('t', '<C-l>', '<C-\\><C-n><C-w>l', { desc = 'Move to right split from terminal' })
-- Cycle through splits with Ctrl+\
map('n', '<C-\\>', '<C-w>w', { desc = 'Cycle through splits' })
map('t', '<C-\\>', '<C-\\><C-n><C-w>w', { desc = 'Cycle through splits from terminal' })
