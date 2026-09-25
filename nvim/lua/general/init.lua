local set = vim.opt

-- Only what differs from Neovim's defaults (hidden, incsearch, autoindent,
-- smarttab, ruler, laststatus=2, encoding=utf-8, backup off and writebackup on
-- are all defaults already; writebackup keeps a copy during a save, so a
-- failed write can't lose the file).
set.exrc = true
set.wrap = false
set.scrolloff = 8
set.colorcolumn = '80'
set.pumheight = 10
set.fileencoding = 'utf-8'
set.splitbelow = true
set.splitright = true
set.conceallevel = 0
set.tabstop = 2
set.shiftwidth = 2
set.expandtab = true
set.smartindent = true
set.number = true
set.relativenumber = true
set.cursorline = true
set.showmode = false
set.updatetime = 300
set.timeoutlen = 500
set.clipboard = 'unnamedplus'

-- Undo history survives closing a file (and feeds the <leader>pu picker)
set.undofile = true

-- Searches ignore case unless the pattern has a capital
set.ignorecase = true
set.smartcase = true

-- YAML under an ansible/ directory or a role is Ansible: that gets it
-- ansiblels and ansible-lint, and the yaml parser still highlights it
vim.filetype.add({
  pattern = {
    [".*/ansible/.*%.ya?ml"] = "yaml.ansible",
    [".*/roles/[^/]+/%a+/.*%.ya?ml"] = "yaml.ansible",
  },
})
vim.treesitter.language.register("yaml", "yaml.ansible")

-- Folds follow the code structure (treesitter), all open to start with;
-- filetypes without a parser just have none. foldtext "" keeps the folded
-- line's own highlighting.
set.foldmethod = 'expr'
set.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
set.foldlevel = 99
set.foldlevelstart = 99
set.foldtext = ''
