return {
  'nvim-telescope/telescope.nvim', tag = '0.1.8',
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = { },
  config = function()
    vim.keymap.set('n', '<leader>d', require('telescope.builtin').diagnostics, { desc = 'Show diagnostics' })
  end
}
