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
let g:syntastic_python_flake8_post_args = "--ignore=E501"
