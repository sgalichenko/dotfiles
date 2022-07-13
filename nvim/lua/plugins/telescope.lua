local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

map('n', '<leader>f', ':Telescope find_files<CR>', opts)
map('n', '<leader>g', ':Telescope live_grep<CR>', opts)
map('n', '<leader>b', ':Telescope buffers<CR>', opts)
map('n', '<leader>h', ':Telescope help_tags<CR>', opts)
map('n', '<leader>m', ':Telescope marks<CR>', opts)
map('n', '<leader>l', ':Telescope current_buffer_fuzzy_finder<CR>', opts)
map('n', '<leader>n', ':Telescope file_browser<CR>', opts)
map('n', '<leader>s', ':Telescope git_status<CR>', opts)

local actions = require("telescope.actions")

require("telescope").setup({
    defaults = {
      prompt_prefix = '  ',
      selection_caret = ' ',
      mappings = {
        i = {
          ["<esc>"] = actions.close,
        },
      },
    },
})
