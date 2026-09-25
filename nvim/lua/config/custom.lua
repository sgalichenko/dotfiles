-- Icons instead of E/W/I/H in the sign column (Nerd Font code points,
-- escaped so no editor or tool can drop the private-use glyphs)
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "\u{f057}", -- nf-fa-times_circle
      [vim.diagnostic.severity.WARN] = "\u{f071}", -- nf-fa-warning
      [vim.diagnostic.severity.INFO] = "\u{f05a}", -- nf-fa-info_circle
      [vim.diagnostic.severity.HINT] = "\u{f0335}", -- nf-md-lightbulb
    },
  },
})

---@param jumpCount number
local function jumpWithVirtLineDiags(jumpCount)
  pcall(vim.api.nvim_del_augroup_by_name, "JumpVirtLineDiags")

  vim.diagnostic.jump { count = jumpCount }

  local orig_virt_text = vim.diagnostic.config().virtual_text

  vim.diagnostic.config {
    virtual_text = false,
    virtual_lines = { current_line = true },
  }

  vim.defer_fn(function()
    vim.api.nvim_create_autocmd("CursorMoved", {
      group = vim.api.nvim_create_augroup("JumpVirtLineDiags", {}),
      once = true,
      callback = function()
        vim.diagnostic.config {
          virtual_lines = false,
          virtual_text = orig_virt_text,
        }
      end,
    })
  end, 1)
end

-- On ]d/[d (Neovim's own diagnostic jumps, extended), so ge/gE keep their
-- "end of previous word" motion
vim.keymap.set("n", "]d", function() jumpWithVirtLineDiags(1) end, { desc = "Next diagnostic (inline)" })
vim.keymap.set("n", "[d", function() jumpWithVirtLineDiags(-1) end, { desc = "Prev diagnostic (inline)" })



local function show_diagnostic_float()
  vim.diagnostic.open_float(nil, {
    scope = "line",
    focusable = false,
    close_events = { "CursorMoved", "InsertEnter", "BufHidden" },
    border = "rounded",
    source = "if_many",
    header = "",
    prefix = "",
    severity_sort = true,
    wrap = true,
    max_width = math.floor(vim.o.columns * 0.6),
    max_height = math.floor(vim.o.lines * 0.4),
  })
end
local function line_has_diagnostics()
  local bufnr = vim.api.nvim_get_current_buf()
  local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
  return not vim.tbl_isempty(vim.diagnostic.get(bufnr, { lnum = lnum }))
end
local last_direction = nil

local function diagnostic_cycle(direction)
  -- direction: 1 (forward), -1 (backward)

  if last_direction == direction then
    -- repeated press → ALWAYS jump
    vim.diagnostic.jump({
      count = direction,
      severity = { min = vim.diagnostic.severity.WARN },
    })
  else
    -- first press in this direction
    if not line_has_diagnostics() then
      vim.diagnostic.jump({
        count = direction,
        severity = { min = vim.diagnostic.severity.WARN },
      })
    end
  end

  last_direction = direction

  vim.defer_fn(show_diagnostic_float, 10)

  -- Moving the cursor yourself ends the streak, so the next press first shows
  -- the diagnostic on whatever line you are then on. Armed after the jump
  -- above has landed, so that jump doesn't count as a move.
  vim.defer_fn(function()
    vim.api.nvim_create_autocmd("CursorMoved", {
      group = vim.api.nvim_create_augroup("DiagnosticCycle", {}),
      once = true,
      callback = function() last_direction = nil end,
    })
  end, 20)
end
vim.keymap.set("n", "gl", function()
  diagnostic_cycle(1)
end, { desc = "Next diagnostic + float" })

vim.keymap.set("n", "gL", function()
  diagnostic_cycle(-1)
end, { desc = "Prev diagnostic + float" })


-- The same float when the cursor rests on a line with diagnostics (after
-- updatetime). Not while an LSP hover (K) is open, which it would cover.
-- <leader>tH turns it off and on.
vim.g.diagnostic_hover = true
vim.api.nvim_create_autocmd("CursorHold", {
  group = vim.api.nvim_create_augroup("DiagnosticHover", {}),
  callback = function()
    if not vim.g.diagnostic_hover or not line_has_diagnostics() then return end
    local hover = vim.b["textDocument/hover"]
    if hover and vim.api.nvim_win_is_valid(hover) then return end
    show_diagnostic_float()
  end,
})
Snacks.toggle({
  name = "Diagnostic Hover",
  get = function() return vim.g.diagnostic_hover end,
  set = function(on) vim.g.diagnostic_hover = on end,
}):map("<leader>tH")

-- Reload files changed outside nvim, e.g. by Claude in the terminal split:
-- nvim only checks by itself when it regains focus, and moving between its
-- own windows doesn't count. Unmodified buffers reload silently (autoread).
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "TermLeave", "TermClose" }, {
  group = vim.api.nvim_create_augroup("Checktime", {}),
  callback = function()
    if vim.fn.mode() ~= "c" and vim.fn.getcmdwintype() == "" then vim.cmd("checktime") end
  end,
})

-- Reopening a file goes back to where the cursor last was (not for commit
-- messages, which are new text each time)
vim.api.nvim_create_autocmd("BufReadPost", {
  group = vim.api.nvim_create_augroup("LastPosition", {}),
  callback = function(ev)
    if vim.tbl_contains({ "gitcommit", "gitrebase" }, vim.bo[ev.buf].filetype) then return end
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(ev.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Briefly highlight what a yank copied
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("YankHighlight", {}),
  callback = function() vim.hl.on_yank() end,
})
