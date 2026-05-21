" Python

" Limit text width to 79 characters by default and display colorcolumn after
" the boundary
let s:python_max_line_length = get(environ(), 'PYTHON_LINE_LENGTH', 79)

let &l:textwidth = s:python_max_line_length
if exists('+colorcolumn')
    let &l:colorcolumn = s:python_max_line_length + 1
endif

let b:ale_linters = ['ruff', 'ruff_format', 'ty', 'mypy']
let b:ale_fixers = ['ruff', 'ruff_format']

for s:manager in ['poetry', 'uv']
    let b:ale_python_auto_{s:manager} = 1
    for s:tool in uniq(sort(b:ale_linters + b:ale_fixers))
        let b:ale_python_{s:tool}_auto_{s:manager} = 1
    endfor
endfor
