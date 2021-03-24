let g:airline_powerline_fonts = 1
let g:airline_theme='bubblegum'
"let g:airline_theme='one'
"let g:airline_theme='deus'
let g:airline_skip_empty_sections = 1
let g:airline#extensions#tabline#enabled = 1
nnoremap <silent> <LocalLeader>[ :bp<CR>
nnoremap <silent> <LocalLeader>] :bn<CR>
" Remove LN sign in airline
let g:airline_symbols = get(g:,'airline_symbols',{})
let g:airline_symbols.maxlinenr=''
