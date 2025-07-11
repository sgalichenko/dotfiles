return {
  'easymotion/vim-easymotion',
  config = function()
    vim.g.EasyMotion_prompt = ' '
    vim.g.EasyMotion_do_mapping = 0
    vim.g.EasyMotion_smartcase = 1
    vim.g.EasyMotion_inc_highlight = 1
    vim.g.EasyMotion_do_shade = 0

    vim.api.nvim_set_keymap('n', 's', '<Plug>(easymotion-sn)', {})
  end
}
