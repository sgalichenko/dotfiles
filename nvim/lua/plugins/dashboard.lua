return {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  config = function()
    vim.api.nvim_set_hl(0, "DashboardHeader", { fg = "#a3b38c", bold = true })
    require('dashboard').setup {
      theme = 'hyper',
      hide = {
        statusline,       -- hide statusline default is true
        tabline,          -- hide the tabline
        winbar           -- hide winbar
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
          { desc = ' Files', group = '@property', action = 'Telescope find_files', key = 'f' },
        },
      },
    }
  end,
  dependencies = { {'nvim-tree/nvim-web-devicons'}}
}
