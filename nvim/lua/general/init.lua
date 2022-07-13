local set = vim.opt

set.exrc = true
set.hidden = true
set.wrap = false
set.errorbells = false
set.incsearch = true
set.scrolloff = 8
set.colorcolumn = '80'
set.termguicolors = true
set.encoding = 'utf-8'
set.pumheight = 10
set.fileencoding = 'utf-8'
set.ruler = true
set.cmdheight = 1
set.mouse = 'a'
set.splitbelow = true
set.splitright = true
set.conceallevel = 0
set.tabstop = 2
set.shiftwidth = 2
set.smarttab = true
set.expandtab = true
set.smartindent = true
set.autoindent = true
set.laststatus = 0
set.number = true
set.relativenumber = true
set.cursorline = true
set.background = 'dark'
set.showtabline = 2
set.showmode = false
set.backup = false
set.writebackup = false
set.updatetime = 300
set.timeoutlen = 500
set.clipboard = 'unnamedplus'

-- Remove trailing whitespaces on save
vim.api.nvim_exec(
[[
fun! TrimWhitespace()
  let l:save = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(l:save)
endfun

augroup Trim
  autocmd!
  autocmd BufWritePre * :call TrimWhitespace()
augroup END
]],
true)
