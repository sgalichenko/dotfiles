-- One set of keys across nvim splits and tmux panes: at the edge of nvim,
-- the move carries on into the neighbouring tmux pane. The tmux side
-- (tmux/.tmux.conf) passes these keys through while nvim has the pane, which
-- the plugin marks with the @pane-is-vim pane option; hence no lazy-loading.
return {
  "mrjones2014/smart-splits.nvim",
  lazy = false,
  opts = {},
  config = function(_, opts)
    local ss = require("smart-splits")
    ss.setup(opts)
    local dirs = { h = "left", j = "down", k = "up", l = "right" }
    local arrows = { h = "Left", j = "Down", k = "Up", l = "Right" }
    for key, dir in pairs(dirs) do
      local move = ss["move_cursor_" .. dir]
      local desc = "Move to " .. dir .. " split/pane"
      -- Alt+hjkl and Ctrl+arrows, the tmux keys, also in terminal buffers
      vim.keymap.set({ "n", "t" }, "<A-" .. key .. ">", move, { desc = desc })
      vim.keymap.set({ "n", "t" }, "<C-" .. arrows[key] .. ">", move, { desc = desc })
      -- Ctrl+hjkl, as before (normal mode; terminal mode kept h/l only)
      vim.keymap.set("n", "<C-" .. key .. ">", move, { desc = desc })
    end
    vim.keymap.set("t", "<C-h>", ss.move_cursor_left, { desc = "Move to left split/pane" })
    vim.keymap.set("t", "<C-l>", ss.move_cursor_right, { desc = "Move to right split/pane" })
  end,
}
