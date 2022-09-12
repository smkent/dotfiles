" Python

" Limit text width to 79 characters by default and display colorcolumn after
" the boundary
let s:python_max_line_length = get(environ(), 'PYTHON_LINE_LENGTH', 79)

let &l:textwidth = s:python_max_line_length
if exists('+colorcolumn')
    let &l:colorcolumn = s:python_max_line_length + 1
endif
