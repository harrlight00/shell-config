syntax on
set shiftwidth=4 tabstop=4 expandtab autoindent

au BufNewFile,BufRead *.xhtml set ft=tt2html
au BufNewFile,BufRead */template/* set ft=tt2html
au BufNewFile,BufRead *.tt set ft=tt2html
au BufNewFile,BufRead *.scss set ft=css

colorscheme zellner

set hidden

set noautoindent
set nocindent
set nosmartindent
set indentexpr=""

set ignorecase

set smartcase

set showcmd

set showmatch

set incsearch

set showmode

set paste

vnoremap <c-c> :CopyToLocal<cr>
command! -range CopyToLocal <line1>,<line2>call CopyToLocal()
function! CopyToLocal() range
:'<,'>w !clip
endfunction
