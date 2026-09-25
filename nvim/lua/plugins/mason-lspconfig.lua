return {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      -- Declared, so a fresh machine gets the same servers; each is enabled
      -- as soon as it is installed
      ensure_installed = {
        "ansiblels", "awk_ls", "bashls", "cssls", "docker_compose_language_service",
        "dockerls", "lua_ls", "pyright", "terraformls", "yamlls",
      },
      -- Every installed server with an lspconfig entry, except stylua: it
      -- is installed as conform's formatter, not to run as a server
      automatic_enable = { exclude = { "stylua" } },
    },
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
    },
}
