-- s jumps to any visible spot by typing a few characters and a label.
-- Only that: f/t/F/T and / keep their plain behaviour.
return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {
    modes = {
      char = { enabled = false },
      search = { enabled = false },
    },
  },
  keys = {
    { "s", function() require("flash").jump() end, desc = "Flash jump" },
  },
}
