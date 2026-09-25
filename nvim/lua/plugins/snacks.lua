return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    dashboard = { enabled = false },
    explorer = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 3000,
    },
    picker = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    styles = {
      notification = {
        -- wo = { wrap = true } -- Wrap notifications
      }
    }
  },
  -- Single keys are the ones from the Telescope days (f, g, b, h, l, d);
  -- the groups that used to collide with them live under other letters:
  -- o open, v git, p pick, t toggle, c code. Each key is a prefix or a
  -- mapping, never both, so none of them waits out timeoutlen.
  keys = {
    -- Top
    { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
    { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
    { "<leader>E", function() Snacks.explorer() end, desc = "File Explorer" },
    -- Single keys
    { "<leader>f", function() Snacks.picker.files() end, desc = "Find Files" },
    { "<leader>g", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>g", function() Snacks.picker.grep_word() end, desc = "Grep Selection", mode = "x" },
    { "<leader>b", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>h", function() Snacks.picker.help() end, desc = "Help Pages" },
    { "<leader>l", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
    { "<leader>d", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    -- Open
    { "<leader>oc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Config File" },
    { "<leader>og", function() Snacks.picker.git_files() end, desc = "Git Files" },
    { "<leader>op", function() Snacks.picker.projects() end, desc = "Projects" },
    { "<leader>or", function() Snacks.picker.recent() end, desc = "Recent" },
    -- Git (<leader>s / <leader>u stage and reset hunks, see git.lua)
    { "<leader>vb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
    { "<leader>vl", function() Snacks.picker.git_log() end, desc = "Git Log" },
    { "<leader>vL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
    { "<leader>vs", function() Snacks.picker.git_status() end, desc = "Git Status" },
    { "<leader>vS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
    { "<leader>vd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
    { "<leader>vf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
    { "<leader>vi", function() Snacks.picker.gh_issue() end, desc = "GitHub Issues (open)" },
    { "<leader>vI", function() Snacks.picker.gh_issue({ state = "all" }) end, desc = "GitHub Issues (all)" },
    { "<leader>vp", function() Snacks.picker.gh_pr() end, desc = "GitHub Pull Requests (open)" },
    { "<leader>vP", function() Snacks.picker.gh_pr({ state = "all" }) end, desc = "GitHub Pull Requests (all)" },
    { "<leader>vB", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
    { "<leader>vg", function() Snacks.lazygit() end, desc = "Lazygit" },
    -- Pick (normal mode only: visual <leader>p pastes from the clipboard)
    { '<leader>p"', function() Snacks.picker.registers() end, desc = "Registers" },
    { "<leader>p/", function() Snacks.picker.search_history() end, desc = "Search History" },
    { "<leader>pa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
    { "<leader>pB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
    { "<leader>pc", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>pC", function() Snacks.picker.commands() end, desc = "Commands" },
    { "<leader>pD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
    { "<leader>pH", function() Snacks.picker.highlights() end, desc = "Highlights" },
    { "<leader>pi", function() Snacks.picker.icons() end, desc = "Icons" },
    { "<leader>pj", function() Snacks.picker.jumps() end, desc = "Jumps" },
    { "<leader>pk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader>pl", function() Snacks.picker.loclist() end, desc = "Location List" },
    { "<leader>pm", function() Snacks.picker.marks() end, desc = "Marks" },
    { "<leader>pM", function() Snacks.picker.man() end, desc = "Man Pages" },
    { "<leader>pp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
    { "<leader>pq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
    { "<leader>pR", function() Snacks.picker.resume() end, desc = "Resume" },
    { "<leader>pu", function() Snacks.picker.undo() end, desc = "Undo History" },
    { "<leader>pw", function() Snacks.picker.grep_word() end, desc = "Grep Word" },
    { "<leader>ps", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
    { "<leader>pS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
    -- Toggles (the rest are created in init below)
    { "<leader>tC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
    { "<leader>tn", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
    -- LSP. References sit on grr rather than gr, so Neovim's grn (rename),
    -- gra (code action), gri and grt stay reachable.
    { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
    { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
    { "grr", function() Snacks.picker.lsp_references() end, desc = "References" },
    { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
    { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
    -- Code (calls under <leader>c rather than ga*, so the built-in ga, the
    -- character code under the cursor, doesn't wait out timeoutlen)
    { "<leader>ci", function() Snacks.picker.lsp_incoming_calls() end, desc = "Calls Incoming" },
    { "<leader>co", function() Snacks.picker.lsp_outgoing_calls() end, desc = "Calls Outgoing" },
    { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
    -- Other
    { "<leader>z",  function() Snacks.zen() end, desc = "Toggle Zen Mode" },
    { "<leader>Z",  function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
    { "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
    { "<leader>S",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
    { "<c-/>",      function() Snacks.terminal() end, desc = "Toggle Terminal" },
    { "<c-_>",      function() Snacks.terminal() end, desc = "which_key_ignore" },
    { "]]",         function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
    { "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
    {
      "<leader>N",
      desc = "Neovim News",
      function()
        Snacks.win({
          file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
          width = 0.6,
          height = 0.6,
          wo = {
            spell = false,
            wrap = false,
            signcolumn = "yes",
            statuscolumn = " ",
            conceallevel = 3,
          },
        })
      end,
    }
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Setup some globals for debugging (lazy-loaded)
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end

        -- Override print to use snacks for `:=` command
        vim._print = function(_, ...)
          dd(...)
        end

        -- Create some toggle mappings
        Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>ts")
        Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>tw")
        Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>tL")
        Snacks.toggle.diagnostics():map("<leader>td")
        Snacks.toggle.line_number():map("<leader>tl")
        Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>tc")
        Snacks.toggle.treesitter():map("<leader>tT")
        Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>tb")
        Snacks.toggle.inlay_hints():map("<leader>th")
        Snacks.toggle.indent():map("<leader>tg")
        Snacks.toggle.dim():map("<leader>tD")
      end,
    })
  end,
}
