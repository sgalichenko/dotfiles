let g:mapleader = "\<Space>"

" Close buffer
nnoremap <leader>x :bd<CR>

" Copy/paste to/from system clipboard
vnoremap <leader>y "+y
vnoremap <leader>Y "+Y
vnoremap <leader>p "+p
vnoremap <leader>P "+P

" Moving highlighted text around
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Highlighting for rasi (e.g. rofi configs)
au BufReadPost *.rasi set syntax=css

" Fast comment / uncomment
vmap # gc<CR>gv=gv

" Keep selection after indentation
vmap < <gv
vmap > >gv


syntax enable

set exrc
set guicursor=
set nohlsearch
set hidden
set nowrap
set noerrorbells
set incsearch
set scrolloff=8
set signcolumn=yes
set colorcolumn=80
set termguicolors
set encoding=utf-8
set pumheight=10
set fileencoding=utf-8
set ruler
set cmdheight=1
set iskeyword+=-
set mouse=a
set splitbelow
set splitright
set conceallevel=0
set tabstop=2
set shiftwidth=2
set smarttab
set expandtab
set smartindent
set autoindent
set laststatus=0
set number
set relativenumber
set nu rnu
set cursorline
set background=dark
set showtabline=2
set noshowmode
set nobackup
set nowritebackup
set updatetime=300
set timeoutlen=500
set clipboard=unnamedplus

au! BufWritePost $MYVIMRC source %
