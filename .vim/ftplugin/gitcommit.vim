" Git commit messages

" Display colorcolumn after the 72-character boundary
if exists('+colorcolumn')
    setlocal colorcolumn=73
endif

" Enable spell checking by default
setlocal spell

" Always start the cursor on the first line
" http://vim.wikia.com/wiki/VimTip1636
call setpos('.', [0, 1, 1, 0])
