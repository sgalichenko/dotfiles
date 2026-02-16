return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8',
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = {
    defaults = {
      prompt_prefix = '  ',
      selection_caret = ' ',
      wrap_results = true,
    },
  },
  config = function(_, opts)
    local telescope = require('telescope')
    local builtin = require('telescope.builtin')

    telescope.setup(opts)

    local keymap = vim.keymap.set
    local km_opts = { noremap = true, silent = true }

    keymap('n', '<leader>f', builtin.find_files, km_opts)
    keymap('n', '<leader>g', builtin.live_grep, km_opts)
    keymap('n', '<leader>b', builtin.buffers, km_opts)
    keymap('n', '<leader>h', builtin.help_tags, km_opts)
    keymap('n', '<leader>m', builtin.marks, km_opts)
    keymap('n', '<leader>l', builtin.current_buffer_fuzzy_find, km_opts)
    keymap('n', '<leader>s', builtin.git_status, km_opts)
    keymap('n', '<leader>d', builtin.diagnostics, { desc = 'Show diagnostics' })

  end,
}
