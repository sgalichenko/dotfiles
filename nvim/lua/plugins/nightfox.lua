return {
  "EdenEast/nightfox.nvim",
  -- Loaded first, so other plugins' highlight groups build on the theme
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd("colorscheme nordfox")
  end,
}
