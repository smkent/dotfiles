" Git interactive rebase instructions

" Replace "pick" with "p" before editing the commit list
silent! %s/^pick/p/g

" Always start the cursor on the first line
" http://vim.wikia.com/wiki/VimTip1636
call setpos('.', [0, 1, 1, 0])
