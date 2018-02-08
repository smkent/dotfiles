" Python

" Limit text width to 79 characters and display colorcolumn after the boundary
setlocal textwidth=79
if exists('+colorcolumn')
    setlocal colorcolumn=80
endif
