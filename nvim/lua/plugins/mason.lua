-- Formatters (conform.lua) and linters (lint.lua) that Mason keeps
-- installed; language servers are listed in mason-lspconfig.lua.
local tools = {
  "shfmt", "stylua", "yamlfmt",
  "shellcheck", "pylint", "markdownlint", "ansible-lint", "gitlint",
}

return {
  "mason-org/mason.nvim",
  opts = {},
  config = function(_, opts)
    require("mason").setup(opts)
    local registry = require("mason-registry")
    -- Installs only what is missing, in the background
    registry.refresh(function()
      for _, name in ipairs(tools) do
        local ok, pkg = pcall(registry.get_package, name)
        if ok and not pkg:is_installed() then pkg:install() end
      end
    end)
  end,
}
