-- The `master` branch is frozen upstream ("provided for backward
-- compatibility only") and is incompatible with Neovim 0.12, which changed
-- query captures from a single node to a list of nodes. master's
-- `set-lang-from-info-string!` directive still indexes a capture as one node,
-- so every language-tagged markdown code fence raised
-- "attempt to call method 'range' (a nil value)".
--
-- `main` dropped that directive in favour of a plain @injection.language
-- capture. It requires Neovim >= 0.12.0 and does not support lazy-loading.
-- Parsers live under stdpath('data')/site; install them with :TSInstall.
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
  },
}
