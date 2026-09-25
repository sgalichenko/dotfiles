-- Pops up the mappings under a prefix (e.g. after <leader>), using their desc
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    spec = {
      { "<leader>a", group = "Claude" },
      { "<leader>c", group = "Code" },
      { "<leader>o", group = "Open" },
      { "<leader>p", group = "Pick", mode = "n" },
      { "<leader>t", group = "Toggle", mode = "n" },
      { "<leader>v", group = "Git" },
    },
  },
}
