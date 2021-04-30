if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  " autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin()

Plug 'dstein64/vim-startuptime'
Plug 'mhinz/vim-startify'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-devicons'

" Themes
Plug 'joshdick/onedark.vim'
Plug 'gruvbox-community/gruvbox'
Plug 'drewtempelmeyer/palenight.vim'
Plug 'rakr/vim-one'
Plug 'ajmwagar/vim-deus'

Plug 'norcalli/nvim-colorizer.lua'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Quick navigation
Plug 'unblevable/quick-scope'
Plug 'easymotion/vim-easymotion'

" Completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Show marks
Plug 'kshenoy/vim-signature'

" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/gv.vim'

" Commenting
Plug 'tpope/vim-commentary'

" Smooth scrolling
Plug 'psliwka/vim-smoothie'

" Lint checks
Plug 'vim-syntastic/syntastic'

" Telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

call plug#end()

colorscheme deus
let g:deus_termcolors=256
"colorscheme one
"colorscheme palenight
"colorscheme onedark
"colorscheme gruvbox

" True colors
if (has('termguicolors'))
  set termguicolors
endif

" Enable transparency
"hi Normal guibg=NONE ctermbg=NONE

let g:startify_custom_header = []
lua require'colorizer'.setup()


" Remove trailing whitespaces on save
fun! TrimWhitespace()
  let l:save = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(l:save)
endfun

augroup Trim
  autocmd!
  autocmd BufWritePre * :call TrimWhitespace()
augroup END


" Set timeout on esc button
if ! has('gui_running')
    set ttimeoutlen=10
    augroup FastEscape
        autocmd!
        au InsertEnter * set timeoutlen=0
        au InsertLeave * set timeoutlen=1000
    augroup END
endif


" Configs
source $HOME/.config/nvim/general/settings.vim
source $HOME/.config/nvim/plugins/airline.vim
source $HOME/.config/nvim/plugins/coc.vim
source $HOME/.config/nvim/plugins/fzf.vim
source $HOME/.config/nvim/plugins/easymotion.vim
source $HOME/.config/nvim/plugins/quickscope.vim
source $HOME/.config/nvim/plugins/syntastic.vim
source $HOME/.config/nvim/plugins/telescope.vim
source $HOME/.config/nvim/plugins/gitgutter.vim
