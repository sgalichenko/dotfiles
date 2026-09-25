-- Formatting. Manual by default (<leader>cf); <leader>tf turns formatting on
-- save on or off. Filetypes without a formatter here fall back to their LSP
-- server, and trailing whitespace is trimmed on every format.
return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  cmd = "ConformInfo",
  keys = {
    {
      "<leader>cf",
      function() require("conform").format({ async = true }) end,
      mode = { "n", "x" },
      desc = "Format",
    },
  },
  opts = {
    formatters_by_ft = {
      sh = { "shfmt" },
      bash = { "shfmt" },
      lua = { "stylua" },
      yaml = { "yamlfmt" },
      ["*"] = { "trim_whitespace" },
    },
    default_format_opts = { lsp_format = "fallback" },
    format_on_save = function()
      if vim.g.format_on_save then return { timeout_ms = 1000 } end
    end,
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        Snacks.toggle({
          name = "Format on Save",
          get = function() return vim.g.format_on_save == true end,
          set = function(on) vim.g.format_on_save = on end,
        }):map("<leader>tf")
      end,
    })
  end,
}
