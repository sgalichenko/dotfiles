" :F brings up fzf search with hidden files etc.
command! -bang -nargs=* F
  \ call fzf#run(fzf#wrap({'source': 'rg --files --hidden --no-ignore-vcs --glob "!{node_modules/*,.git/*}"', 'down': '40%', 'options': '--expect=ctrl-t,ctrl-x,ctrl-v --multi --reverse' }))
"nnoremap <leader>f :Files<cr>
"nnoremap <leader>l :Lines<cr>
"nnoremap <leader>b :Buffers<cr>
