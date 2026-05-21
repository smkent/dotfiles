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

let b:ale_python_auto_poetry = 1
let b:ale_python_mypy_auto_poetry = 1
let b:ale_python_ruff_auto_poetry = 1
let b:ale_python_ruff_format_auto_poetry = 1
let b:ale_python_ty_auto_poetry = 1

let b:ale_python_auto_uv = 1
let b:ale_python_mypy_auto_uv = 1
let b:ale_python_ruff_auto_uv = 1
let b:ale_python_ruff_format_auto_uv = 1
let b:ale_python_ty_auto_uv = 1
