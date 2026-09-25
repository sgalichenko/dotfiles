return {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  config = function()
    vim.api.nvim_set_hl(0, "DashboardHeader", { fg = "#a3b38c", bold = true })
    require('dashboard').setup {
      theme = 'hyper',
      hide = {
        statusline = true,
        tabline = true,
        winbar = true,
      },
      config = {
        packages = { enable = true },
        header = { "NVIM " .. vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch },
        footer = {},
        -- week_header = {
        --  enable = true,
        -- },
        shortcut = {
          { desc = '󰊳 Lazy', group = '@property', action = 'Lazy', key = 'l' },
          { desc = '󰭷 Mason', group = '@property', action = 'Mason', key = 'm' },
          { desc = ' Files', group = '@property', action = function() Snacks.picker.files() end, key = 'f' },
        },
      },
    }
  end,
  dependencies = { {'nvim-tree/nvim-web-devicons'}}
}
