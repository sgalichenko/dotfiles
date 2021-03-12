" Configs
source $HOME/.config/nvim/general/settings.vim
source $HOME/.config/nvim/plug-config/coc.vim

" PLUGINS "
" Install vim-plug if it doesn't installed yet
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

Plug 'dstein64/vim-startuptime'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeFind' }
Plug 'ryanoasis/vim-devicons'

Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'sainnhe/forest-night'
Plug 'flazz/vim-colorschemes'
Plug 'xolox/vim-misc'
Plug 'machakann/vim-highlightedyank'

Plug 'norcalli/nvim-colorizer.lua' " Color codes to color

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/seoul256.vim'

Plug 'mhinz/vim-startify'

" Quick navigation
Plug 'unblevable/quick-scope'
Plug 'justinmk/vim-sneak'

" Completion plugin
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Vim practice
Plug 'ThePrimeagen/vim-be-good', {'do': './install.sh'}

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

" Lint checker
"Plug 'dense-analysis/ale'
Plug 'vim-syntastic/syntastic'

call plug#end()

"colorscheme gruvbox
"colorscheme neodark
colorscheme deus
"colorscheme seoul256
"colorscheme forest-night
"colorscheme colorsbox-material
"colorscheme dracula
"colorscheme termschool
"colorscheme material
"colorscheme 1989
"colorscheme vorange
"colorscheme thornbird
"colorscheme tender
"colorscheme synthwave
"colorscheme OceanicNext
"colorscheme materialbox
set background=dark


let g:startify_custom_header = []

" True colors
" For Neovim 0.1.3 and 0.1.4 - https://github.com/neovim/neovim/pull/2198
if (has('nvim'))
  let $NVIM_TUI_ENABLE_TRUE_COLOR = 1
endif
" For Neovim > 0.1.5 and Vim > patch 7.4.1799 - https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162
" Based on Vim patch 7.4.1770 (`guicolors` option) - https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd
" https://github.com/neovim/neovim/wiki/Following-HEAD#20160511
if (has('termguicolors'))
  set termguicolors
endif


" Enable colorcodes
lua require'colorizer'.setup()


" Enable transparency
"hi Normal guibg=NONE ctermbg=NONE


" Higlight when yanking
" Plugin machakann/vim-highlightedyank
" Set duration (-1 means persistent)
" let g:highlightedyank_highlight_duration = 1000
let g:highlightedyank_highlight_duration = -1
" Color when yanking
highlight HighlightedyankRegion cterm=reverse gui=reverse



" fzf
" https://github.com/junegunn/fzf.vim
set rtp+=/home/linuxbrew/.linuxbrew/opt/fzf
" :F brings up fzf search with hidden files etc.
command! -bang -nargs=* F
  \ call fzf#run(fzf#wrap({'source': 'rg --files --hidden --no-ignore-vcs --glob "!{node_modules/*,.git/*}"', 'down': '40%', 'options': '--expect=ctrl-t,ctrl-x,ctrl-v --multi --reverse' }))
" Map Space+o to open fzf in vim
nnoremap <silent> <leader>f :Files<cr>
nnoremap <silent> <leader>l :Lines<cr>
nnoremap <silent> <leader>b :Buffers<cr>




" Quickscope configuration
" Trigger a highlight in the appropriate direction when pressing these keys:
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
highlight QuickScopePrimary guifg=#44475A gui=underline,bold guibg=#AFD787 cterm=underline,bold
highlight QuickScopeSecondary guifg=#44475A gui=underline,bold guibg=#FCBF49 cterm=underline,bold
let g:qs_max_chars=150
set relativenumber





" Sneak configuration
let g:sneak#label = 1

" case insensitive sneak
let g:sneak#use_ic_scs = 1

" immediately move to the next instance of search, if you move the cursor sneak is back to default behavior
let g:sneak#s_next = 1

" remap so I can use , and ; with f and t
map gS <Plug>Sneak_,
map gs <Plug>Sneak_;

" Change the colors
highlight Sneak guifg=#44475A guibg=#FCBF49 gui=underline,bold ctermfg=black ctermbg=cyan
highlight SneakScope guifg=#44475A guibg=#AFD787 gui=underline,bold ctermfg=red ctermbg=yellow

" Cool prompts
" let g:sneak#prompt = 'ioio'
" let g:sneak#prompt = 'oioi'

" I like quickscope better for this since it keeps me in the scope of a single line
" map f <Plug>Sneak_f
" map F <Plug>Sneak_F
" map t <Plug>Sneak_t
" map T <Plug>Sneak_T




" NERDTREE "

" Set keybinding backslash+n to open nerdtree
nnoremap <silent> <Leader>n :NERDTreeFind<CR>
" Autoclose NT when file being opened
let NERDTreeQuitOnOpen = 1
" Remove \"press ? for help\" message
let NERDTreeMinimalUI = 1
" Make it prittier
let NERDTreeDirArrows = 1




" AIRLINE "

let g:airline_powerline_fonts = 1
let g:airline_theme='bubblegum'
let g:airline_skip_empty_sections = 1
" Remove -- INSERT -- text under status line
set noshowmode
" Configure tabs/buffers
let g:airline#extensions#tabline#enabled = 1
nnoremap <silent> <LocalLeader>[ :bp<CR>
nnoremap <silent> <LocalLeader>] :bn<CR>
" Remove LN sign in airline
let g:airline_symbols = get(g:,'airline_symbols',{})
let g:airline_symbols.maxlinenr=''



" Set timeout on esc button
if ! has('gui_running')
    set ttimeoutlen=10
    augroup FastEscape
        autocmd!
        au InsertEnter * set timeoutlen=0
        au InsertLeave * set timeoutlen=1000
    augroup END
endif



" Copy to system clipboard
vnoremap  <leader>y  "+y
nnoremap  <leader>Y  "+yg_
nnoremap  <leader>y  "+y
nnoremap  <leader>yy "+yy

" Paste from system clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P


" Moving highlighted text around
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Delete buffer
nnoremap <silent> <leader>x :bd<cr>

" Highlighting for rofi configs
au BufReadPost *.rasi set syntax=css


" Fast comment / uncomment
vmap # gc<CR>gv=gv

" Keep selection after indentation
vmap < <gv
vmap > >gv


" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
" Error symbols         
let g:syntastic_error_symbol = ""
let syntastic_style_error_symbol = ""
let g:syntastic_warning_symbol = ""
let syntastic_style_warning_symbol = ""
let syntastic_quiet_messages = {}
