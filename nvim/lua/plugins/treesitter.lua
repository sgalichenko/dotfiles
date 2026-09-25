-- The `master` branch is frozen upstream ("provided for backward
-- compatibility only") and is incompatible with Neovim 0.12, which changed
-- query captures from a single node to a list of nodes. master's
-- `set-lang-from-info-string!` directive still indexes a capture as one node,
-- so every language-tagged markdown code fence raised
-- "attempt to call method 'range' (a nil value)".
--
-- `main` dropped that directive in favour of a plain @injection.language
-- capture. It requires Neovim >= 0.12.0 and does not support lazy-loading.
-- Parsers live under stdpath('data')/site and are built with the tree-sitter
-- CLI (brew install tree-sitter-cli) and a C compiler.
--
-- Unlike master, main neither installs parsers nor turns highlighting on by
-- itself: both happen in config below.
local parsers = {
  "bash", "css", "diff", "dockerfile", "git_rebase", "gitcommit", "gitignore",
  "go", "hcl", "html", "ini", "javascript", "jinja", "jinja_inline", "json",
  "lua", "luadoc", "make", "markdown", "markdown_inline", "python", "query",
  "regex", "sql", "terraform", "toml", "vim", "vimdoc", "xml", "yaml",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      -- Installs only what is missing, in the background
      require("nvim-treesitter").install(parsers)

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("TreesitterStart", {}),
        callback = function(ev)
          local lang = vim.treesitter.language.get_lang(ev.match)
          -- Fails quietly for filetypes without a parser, which keep regex syntax
          if lang and pcall(vim.treesitter.start, ev.buf, lang) then
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}
