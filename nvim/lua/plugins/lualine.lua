return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      options = {
        icons_enabled = true,
        -- follows the colorscheme (nightfox ships a nordfox theme)
        theme = 'auto',
        component_separators = { left = ' ⏽ ', right = ' ⏽ '},
        section_separators = { left = '', right = ''},
        disabled_filetypes = {},
        always_divide_middle = true,
      }
    }
}
