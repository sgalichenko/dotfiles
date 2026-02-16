return {
  'developedbyed/marko.nvim',
  config = function()
    require('marko').setup({
      width = 100,
      height = 100,
      border = "single",
      title = " Marks ",
      virtual_text = {
        enabled = true,        -- Enable virtual text marks
        icon = "●",           -- Icon to display
        hl_group = "Comment", -- Highlight group
        position = "eol",     -- Position: "eol" or "overlay"
      },
    })
  end,
}
