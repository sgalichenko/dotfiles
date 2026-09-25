-- Teaches lua_ls about Neovim: the vim.* API, and the plugins lazy.nvim
-- manages (Snacks and friends), only for the modules a file actually uses.
-- Without it, every file in this config reports "Undefined global `vim`".
return {
  "folke/lazydev.nvim",
  ft = "lua",
  opts = {
    library = {
      -- vim.uv types, loaded when a file mentions vim.uv
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      -- The Snacks global, which no require() would pull in
      { path = "snacks.nvim", words = { "Snacks" } },
    },
  },
}
