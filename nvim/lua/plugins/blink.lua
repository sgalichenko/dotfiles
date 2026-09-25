-- Completion as you type: LSP, paths, snippets and words from the buffer.
-- Loaded at startup, not on InsertEnter, so its LSP capabilities are in place
-- before the first server attaches.
return {
  "saghen/blink.cmp",
  version = "1.*",
  lazy = false,
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- <C-y> accept, <C-space> open/docs, <C-e> close, <C-n>/<C-p> move,
    -- <Tab>/<S-Tab> through snippet fields
    keymap = { preset = "default" },
    appearance = { nerd_font_variant = "mono" },
    completion = {
      documentation = { auto_show = true, auto_show_delay_ms = 300 },
    },
    signature = { enabled = true },
    sources = {
      default = { "lazydev", "lsp", "path", "snippets", "buffer" },
      providers = {
        -- Neovim API and plugin completions in Lua files (plugins/lazydev.lua),
        -- ranked above lua_ls's own
        lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
      },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
}
