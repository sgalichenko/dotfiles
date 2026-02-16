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

vim.keymap.set("n", "ge", function() jumpWithVirtLineDiags(1) end)
vim.keymap.set("n", "gE", function() jumpWithVirtLineDiags(-1) end)



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
end
vim.keymap.set("n", "gl", function()
  diagnostic_cycle(1)
end, { desc = "Next diagnostic + float" })

vim.keymap.set("n", "gL", function()
  diagnostic_cycle(-1)
end, { desc = "Prev diagnostic + float" })

