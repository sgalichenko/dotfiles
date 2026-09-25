-- Linters that no language server runs. Shell is covered by bashls (it runs
-- shellcheck itself) and Python types and imports by pyright, so pylint
-- leaves import errors to pyright: its own venv under Mason can't see a
-- project's packages and would flag every third-party import.
return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPost", "BufNewFile", "BufWritePost" },
  config = function()
    local lint = require("lint")
    lint.linters_by_ft = {
      python = { "pylint" },
      markdown = { "markdownlint" },
      ["yaml.ansible"] = { "ansible_lint" },
      gitcommit = { "gitlint" },
    }
    lint.linters.pylint.args = vim.list_extend(
      { "--disable=import-error" },
      lint.linters.pylint.args
    )

    vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
      group = vim.api.nvim_create_augroup("Lint", {}),
      callback = function() lint.try_lint() end,
    })
    -- The events above have already fired for the buffer that loaded us.
    -- Scheduled: we load in the middle of its BufReadPost, before its
    -- filetype (and so its linters) is known.
    vim.schedule(lint.try_lint)
  end,
}
