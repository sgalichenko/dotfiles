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

-- Fast comment / uncomment, with Neovim's built-in gc
map('x', '#', 'gc', { remap = true, silent = true })

-- Keep selection after indentation
map('v', '<', '<gv', opts)
map('v', '>', '>gv', opts)

-- Diagnostics: <leader>d lists them all, gl/gL show the one under the cursor
-- (config/custom.lua)

--- Tables (visual <leader>t, so plain t keeps its "till character" motion)
map('v', '<leader>t', ":! tr -s ' ' | column -t -s '|' -o '  |  '| sed 's/^[[:space:]]*//;s/[[:space:]]*$//'<CR>", opts)

--- Execute command
map('v', '<leader>e', ":y<CR>p0v$:!sh<CR>", opts)
map('n', '<leader>e', "0v$:y<CR>p0v$:!sh<CR>", opts)

-- Moving between splits (and on into tmux panes) is in plugins/smart-splits.lua
-- Cycle through splits with Ctrl+\
map('n', '<C-\\>', '<C-w>w', { desc = 'Cycle through splits' })
map('t', '<C-\\>', '<C-\\><C-n><C-w>w', { desc = 'Cycle through splits from terminal' })
