" JavaScript, TypeScript (symlink), TypeScript React (symlink)

setlocal expandtab
setlocal tabstop=2
setlocal softtabstop=2
setlocal shiftwidth=2

let b:ale_linters = ['eslint', 'tsserver']
let b:ale_fixers = ['oxfmt']

setlocal textwidth=0
if exists('+colorcolumn')
    setlocal colorcolumn=81
endif

call ALEAddLSPMappings()
