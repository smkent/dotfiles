" Basic settings {{{

" Several basic settings and some mappings from https://github.com/gergap/vim

" Disable vi compatibility (emulation of old bugs)
set nocompatible

" set UTF-8 encoding
set encoding=utf-8
set fileencoding=utf-8
scriptencoding utf-8
set termencoding=utf-8

" Indentation settings
set autoindent      " Use indentation of previous line
set smartindent     " Use intelligent indentation for code

" Set tab width to 4
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab       " Insert spaces instead of tabs
filetype indent plugin on

set hlsearch        " Highlight search results
set incsearch       " Show search matches as you type

" Color settings
set t_Co=256        " Enable 256 colors
syntax on           " Enable syntax highlighting
colorscheme smkent

set number          " Show line numbers
set relativenumber  " Show relative line numbers (except for the current line)
set showmatch       " Show matching braces

set nowrap          " Don't wrap long lines

" Use one space instead of two after periods when formatting paragraphs
set nojoinspaces

" Highlight certain nonprintable characters
set list
set listchars=nbsp:¬,tab:»\ ,extends:»,precedes:«

set mouse=          " Disable mouse support
set so=2            " so is "Scrolloff", or the minimum number of context
                    " lines that are displayed above/below the cursor.

" Enable command line completion
set wildmenu
set wildmode=longest:full,full

" Set custom timeout exiting insert mode
" The default timeout is much higher, resulting in a delay exiting insert mode
set timeout timeoutlen=1000 ttimeoutlen=50

" Disable vim requesting the terminal version
" This prevents extraneous garbage from being printed on startup
set t_RV=

" Disable swap file fsync to prevent Vim from blocking when writing swap files
set swapsync=

" Open preview splits at the bottom instead of the top
set splitbelow

" Allow execution of project-specific .vimrc files
if getcwd() != $HOME
    set exrc
    set secure
endif

" }}}

" Basic autocommands {{{

augroup basic_autocommands
    autocmd!

    " 80-character column highlight
    " http://stackoverflow.com/a/3765575
    if exists('+colorcolumn')
        set colorcolumn=81
    else
        autocmd BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
    endif

    " Highlight trailing whitespace in red (allow per-buffer override)
    " http://vim.wikia.com/wiki/VimTip396
    autocmd BufWinEnter *
        \ if get(b:, 'highlight_trailing_whitespace', 1) |
        \     call matchadd('Error', '\s\+$', 5) |
        \ endif
    if version >= 702
        autocmd BufWinLeave * call clearmatches()
    endif

    " Open help windows vertically if space permits
    " Based on http://vi.stackexchange.com/a/4464
    autocmd BufWinEnter *.txt if &buftype == 'help' |
        \ if &columns >= 160 | wincmd H | else | wincmd K | endif | endif
augroup END

" }}}

" Keyboard mappings {{{

" Several mappings are from YADR: https://github.com/skwp/dotfiles

let mapleader=","

" http://superuser.com/a/402084
if &term =~ '^screen'
    " tmux will send xterm-style keys when its xterm-keys option is on
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
endif

" Resize windows with arrow keys
" Up and down are reversed compared to YADR's example
nnoremap <C-Up> <C-w>-
nnoremap <C-Down> <C-w>+
nnoremap <C-Left> <C-w><
nnoremap <C-Right>  <C-w>>

" Mappings for creating splits that span an entire edge of the editor
" Idea from:
" https://technotales.wordpress.com/2010/04/29/
" vim-splits-a-guide-to-doing-exactly-what-you-want/
nnoremap <silent> <C-w>l :botright vsplit<CR>
nnoremap <silent> <C-w>j :botright split<CR>
nnoremap <silent> <C-w>h :topleft vsplit<CR>
nnoremap <silent> <C-w>k :topleft split<CR>

" Make 0 go to the first character rather than the beginning
" of the line. When we're programming, we're almost always
" interested in working with text rather than empty space. If
" you want the traditional beginning of line, use ^
nnoremap 0 ^
nnoremap ^ 0

" F2 and Ctrl+S:
" In normal mode, save the file
" In insert mode, exit insert mode, save the file, and enter insert mode
nmap <F2> :w<CR>
nmap <C-s> :w<CR>
" `^ prevents the cursor from backing up one character when exiting and
" re-entering insert mode
" http://stackoverflow.com/a/2296229
imap <F2> <ESC>:w<CR>`^i
imap <C-s> <ESC>:w<CR>`^i

" F3: Clear last search highlighting
nnoremap <silent> <F3> :noh<return><esc>

" F4: Toggle paste mode
set pastetoggle=<F4>
function! TogglePaste() abort
    " Toggle paste mode
    set paste!
    " Enable/disable completor based on new paste state
    let g:completor_auto_trigger = (1 - &paste)
endfunction
nnoremap <silent> <F4> :call TogglePaste()<CR>

" F9: Toggle spell checking
nnoremap <silent> <F9> :setlocal spell!<CR>
inoremap <F9> <ESC>:setlocal spell!<CR>`^i

" Navigate the location list using [l and ]l.
" If the location list is empty, take no action.
" If the location list is populated, open it if it was closed.
" If the cursor is not positioned on the line for the currently selected item
" in the location list, move the cursor to the currently selected item.
" Otherwise, navigate to the previous/next location list item.
" Wrap the selection when moving past the beginning/end of the location list.
function! NavigateWrapLocationList(next)  " {{{
    " a:next is 1 for next location, 0 for previous location
    try
        if a:next | lnext | else | lprev | endif
    catch /E42/     " No errors
    catch /E553/    " No more items
        " Wrap list
        if a:next | lfirst | else | llast | endif
    endtry
endfunction  " }}}
nmap <silent> ]l :call NavigateWrapLocationList(1)<CR>
nmap <silent> [l :call NavigateWrapLocationList(0)<CR>
" nmap <silent> ]l :lnext<CR>
" nmap <silent> [l :lprev<CR>
nmap <silent> [L :lfirst<CR>
nmap <silent> ]L :llast<CR>

" Navigate SCM conflict markers with [n and ]n.
" From vim-unimpaired: https://github.com/tpope/vim-unimpaired
" Context and ContextMotion helper functions {{{
function! Context(reverse)
    call search('^\(@@ .* @@\|[<=>|]\{7}[<=>|]\@!\)', a:reverse ? 'bW' : 'W')
endfunction

function! ContextMotion(reverse)
    if a:reverse
        -
    endif
    call search('^@@ .* @@\|^diff \|^[<=>|]\{7}[<=>|]\@!', 'bWc')
    if getline('.') =~# '^diff '
        let end = search('^diff ', 'Wn') - 1
        if end < 0
            let end = line('$')
        endif
    elseif getline('.') =~# '^@@ '
        let end = search('^@@ .* @@\|^diff ', 'Wn') - 1
        if end < 0
            let end = line('$')
        endif
    elseif getline('.') =~# '^=\{7\}'
        +
        let end = search('^>\{7}>\@!', 'Wnc')
    elseif getline('.') =~# '^[<=>|]\{7\}'
        let end = search('^[<=>|]\{7}[<=>|]\@!', 'Wn') - 1
    else
        return
    endif
    if end > line('.')
        execute 'normal! V'.(end - line('.')).'j'
    elseif end == line('.')
        normal! V
    endif
endfunction
" }}}
nmap <silent> [n :<C-U>call Context(1)<CR>
nmap <silent> ]n :<C-U>call Context(0)<CR>
omap <silent> [n :<C-U>call ContextMotion(1)<CR>
omap <silent> ]n :<C-U>call ContextMotion(0)<CR>

" Navigate tags with ]t and [t
nnoremap <silent> [t :<C-U>tprev<CR>
nnoremap <silent> ]t :<C-U>tnext<CR>
nnoremap <silent> [T :<C-U>tfirst<CR>
nnoremap <silent> ]T :<C-U>tlast<CR>

" Remap record (q) to ,q so q can be used to quit vim
nnoremap <Leader>q q

" Remap Ctrl+e and Ctrl+y so they can be used elsewhere
nnoremap <Leader>e <C-e>
nnoremap <Leader>y <C-y>

" Paste from the system clipboard with ,p and ,P
nnoremap <Leader>p "+p
nnoremap <Leader>P "+Pl

" Surround shortcuts
map <Leader>' ysiW'
vmap <Leader>' c'<C-R>"'<ESC>
map <Leader>" ysiW"
vmap <Leader>" c"<C-R>""<ESC>

" ,) or ,( Surround a word with (parens)
" The difference is in whether a space is put in
map <Leader>( ysiw(
map <Leader>) ysiw)
vmap <Leader>( c( <C-R>" )<ESC>
vmap <Leader>) c(<C-R>")<ESC>

" ,[ Surround a word with [brackets]
map <Leader>] ysiw]
map <Leader>[ ysiw[
vmap <Leader>[ c[ <C-R>" ]<ESC>
vmap <Leader>] c[<C-R>"]<ESC>

" ,{ Surround a word with {braces}
map <Leader>} ysiw}
map <Leader>{ ysiw{
vmap <Leader>} c{ <C-R>" }<ESC>
vmap <Leader>{ c{<C-R>"}<ESC>

" ,` Surround a word with `backticks`
map <Leader>` ysiw`

" Surround contents replacement shortcuts
nnoremap <Leader>r' f'ci'
nnoremap <Leader>r" f"ci"
nnoremap <Leader>r` f`ci`
nnoremap <Leader>r( f(ci(
nnoremap <Leader>r) f)ci)
nnoremap <Leader>r[ f[ci[
nnoremap <Leader>r] f]ci]
nnoremap <Leader>r{ f{ci{
nnoremap <Leader>r} f}ci}

" Break current line at cursor, removing any trailing whitespace
nmap <Leader>s i<CR><Esc>k:silent! s/\s\+$//<CR>:noh<CR>$

" Insert blank lines above or below with [<Space> or ]<Space>
" From vim-unimpaired: https://github.com/tpope/vim-unimpaired
" BlankUp and BlankDown helper functions {{{
function! BlankUp(count) abort
    put!=repeat(nr2char(10), a:count)
    ']+1
endfunction

function! BlankDown(count) abort
    put =repeat(nr2char(10), a:count)
    '[-1
endfunction
" }}}
nmap [<Space> :<C-U>call BlankUp(v:count1)<CR>
nmap ]<Space> :<C-U>call BlankDown(v:count1)<CR>

" Confirm and quit using q in normal mode
nnoremap <silent> q :conf q<cr>

" Remap Q to save and quit. This also disables Ex mode.
nnoremap <silent> Q :wq<cr>

" Use ,W to save the current file with sudo
nnoremap <Leader>W :w !sudo tee > /dev/null %<CR>

" Show the current buffer name in the status bar with <Leader>f
nnoremap <Leader>f :echo @%<CR>

" Show the current buffer's absolute path in the status bar with <Leader>F
nnoremap <Leader>F :echo expand('%:p')<CR>

" Redraw the screen with <Leader>.
nnoremap <silent> <Leader>. :redraw!<CR>

" }}}

" Plugin installation {{{

" Define list of plugins to be installed
silent call plug#begin()  " Suppress error message if git is not installed
Plug 'https://github.com/christoomey/vim-tmux-navigator'
Plug 'https://github.com/ctrlpvim/ctrlp.vim'
Plug 'https://github.com/davidhalter/jedi-vim'
Plug 'https://github.com/dense-analysis/ale'
Plug 'https://github.com/fatih/vim-go',
            \ { 'do': ':GoUpdateBinaries' }
Plug 'https://github.com/jamessan/vim-gnupg',
            \ { 'branch': 'main' }
Plug 'https://github.com/jeffkreeftmeijer/vim-numbertoggle'
Plug 'https://github.com/junegunn/fzf',
            \ {
            \     'dir': '~/.fzf',
            \     'do': './install --completion --no-update-rc --no-key-bindings',
            \ }
Plug 'https://github.com/junegunn/fzf.vim'
Plug 'https://github.com/honza/vim-snippets'
Plug 'https://github.com/hynek/vim-python-pep8-indent'
if v:version >= 704
    Plug 'https://github.com/ludovicchabant/vim-gutentags'
endif
Plug 'https://github.com/maralla/completor.vim'
Plug 'https://github.com/SirVer/ultisnips'
Plug 'https://github.com/smkent/vim-pipe-preview'
Plug 'https://github.com/stephpy/vim-yaml'
Plug 'https://github.com/tomtom/tcomment_vim'
Plug 'https://github.com/tpope/vim-fugitive'
Plug 'https://github.com/tpope/vim-surround'
Plug 'https://github.com/vim-airline/vim-airline'
Plug 'https://github.com/vim-scripts/AnsiEsc.vim'
" vim-gitgutter with real-time sign updates enabled occasionally produced
" rendering errors prior to Vim 7.4.427. For more information, see:
" - https://github.com/airblade/vim-gitgutter/issues/171
" - http://ftp.vim.org/vim/patches/7.4/7.4.427
if executable('git')
    if has('patch-7.4.427')
        Plug 'https://github.com/airblade/vim-gitgutter'
        " Reduce default refresh time from 4 seconds to 0.25 seconds
        set updatetime=250
    else
        Plug 'https://github.com/mhinz/vim-signify'
    endif
endif
call plug#end()

" Install plugins automatically if needed and if VIM_SKIP_PLUGINS is unset or 0
if empty($VIM_SKIP_PLUGINS) || $VIM_SKIP_PLUGINS == 0
    if !empty(filter(copy(g:plugs), '!isdirectory(v:val.dir)'))
        if executable('git')
            PlugInstall | q
        endif
    endif
endif

" }}}

" vim-airline configuration {{{

set laststatus=2    " Always show the status bar
set noshowmode      " vim-airline already shows the current mode

" Enable powerline fonts unless explicitly disabled
if empty($VIM_AIRLINE) || $VIM_AIRLINE != 0
    let g:airline_powerline_fonts = 1
else
    let g:airline_powerline_fonts = 0
    " Use spaces instead of carats if custom fonts are disabled
    if !exists('g:airline_symbols')
        let g:airline_symbols = {}
    endif
    let g:airline_left_sep=' '
    let g:airline_right_sep=' '
    let g:airline_left_alt_sep=' '
    let g:airline_right_alt_sep=' '
endif

" Set vim-airline color theme to smkent
let g:airline_theme = "smkent"

" Set custom airline symbols
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.linenr = ''

" Customize right statusbar section contents
let g:airline_section_x = airline#section#create_right(
    \ ['tagbar', 'filetype', 'ffenc'])
let g:airline_section_y = airline#section#create(['%3p%%'])
let g:airline_section_z = airline#section#create(['linenr', ':%3c '])

" }}}

" vim-signify configuration {{{

let g:signify_vcs_list = [ 'git' ]

" Map [c and ]c shortcuts to jump between hunks
let g:signify_mapping_next_hunk = ']c'
let g:signify_mapping_prev_hunk = '[c'

" vim-signify integration with vim-airline
" Only show modified counts in the status bar if they're non zero
let g:airline#extensions#hunks#non_zero_only = 1

let g:signify_sign_add = '+'
let g:signify_sign_delete = '<'
let g:signify_sign_change = '|'
let g:signify_sign_delete_first_line = '^^'
let g:signify_sign_changedelete = g:signify_sign_change . g:signify_sign_delete

" }}}

" vim-gitgutter configuration {{{

" Customize sign characters
let g:gitgutter_highlight_lines = 0
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_removed = '<'
let g:gitgutter_sign_modified = '|'
let g:gitgutter_sign_removed_first_line = '^^'
let g:gitgutter_sign_modified_removed =
    \ g:gitgutter_sign_modified . g:gitgutter_sign_removed

" Customize sign column highlight
" Highlight groups are located in my color scheme file
" See the section "Plugin highlight groups" in that file
let g:gitgutter_override_sign_column_highlight = 0

" }}}

" fzf configuration {{{

nnoremap <silent> <C-e> :Buffers<CR>
nnoremap <silent> <C-@> :Tags<CR>
nnoremap <silent> <C-p> :GFiles<CR>
nnoremap <silent> <Leader>o :History<CR>

let g:fzf_colors = {
            \ 'pointer': ['fg', 'Title'],
            \ 'spinner': ['fg', 'Constant'],
            \ }

" }}}

" CtrlP configuration {{{

let g:ctrlp_map = '<Leader><Leader>p'
let g:ctrlp_cmd = 'CtrlPMixed'
let g:ctrlp_max_depth = 5
let g:ctrlp_max_files = 30000
let g:ctrlp_show_hidden = 1
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_user_command = {
    \ 'types': {
        \ 1: ['.git', 'cd %s && git ls-files . -co --exclude-standard'],
        \ },
    \ 'fallback': 'find %s -type f'
    \ }

" }}}

" ALE configuration {{{

" Basic settings
let g:ale_open_list = 0
let g:airline#extensions#ale#enabled = 1
let g:ale_fix_on_save = 1

" Sign column symbols
let g:ale_sign_error = "✖"             " Block X
let g:ale_sign_warning = "⚠"           " Warning sign symbol
let g:ale_sign_style_error = "⇢"       " Dotted right arrow
let g:ale_sign_style_warning = g:ale_sign_style_error

" Linters and fixers
let g:ale_python_black_auto_poetry = 1
let g:ale_python_flake8_auto_poetry = 1
let g:ale_python_isort_auto_poetry = 1
let g:ale_python_mypy_auto_poetry = 1
let g:ale_fixers = {
            \ 'python': ['black', 'isort'],
            \ }

let g:ale_python_black_options = "-l 79"

" ALE control mappings
" Functions to control ALE on a per-buffer basis {{{
function! ALEToggleEnabled()
    " Idea from http://stackoverflow.com/a/36683733
    if &filetype == 'qf'
        " The location window is focused. Close it so this action will apply
        " to the corresponding buffer.
        lclose | lclose
    endif
    ALEToggleBuffer
    echo 'ALE ' .
        \ (get(b:, 'ale_enabled', 1) == 1 ? 'enabled' : 'disabled') .
        \ ' for "' . @% . '"'
endfunction

function! ALEToggleVerbosity()
    if &filetype == 'qf'
        " The location window is focused. Close it so this action will apply
        " to the corresponding buffer.
        lclose | lclose
    endif
    let b:ale_quiet = 1 - get(b:, 'ale_quiet', 0)
    if b:ale_quiet == 0
        let b:ignore_arg_ale_python_flake8 = ''
    else
        let b:ignore_arg_ale_python_flake8 = '--ignore=W,E,F4'
    endif
    let b:ale_python_flake8_options =
        \ get(b:, 'base_ale_python_flake8_options', '') . ' ' .
        \ b:ignore_arg_ale_python_flake8
    ALELint
    echo 'ALE verbosity ' .
        \ (empty(b:ignore_arg_ale_python_flake8) ? 'increased' : 'reduced') .
        \ ' for "' . @% . '"'
endfunction

function! ToggleLocationList()
    let l:old_last_winnr = winnr('$')
    lclose | lclose
    if l:old_last_winnr == winnr('$')
        " Nothing was closed, open ALE error location panel
        if len(getloclist(winnr('$')))
            lopen
        endif
    endif
endfunction

" }}}
nmap <silent> <Leader>l :call ToggleLocationList()<CR>
nmap <silent> <Leader>d :call ALEToggleEnabled()<CR>
nmap <silent> <C-y> :call ALEToggleVerbosity()<CR>
nnoremap <F10> :ALEFix<CR>

" }}}

" tcomment configuration {{{

" By default, tcomment's gcc mapping uses the count to repeat the comment
" instead of commenting out the specified number of lines. This configuration
" uses the count with gcc to toggle comments for the specified number of
" lines instead.
" https://github.com/tomtom/tcomment_vim/issues/105
"
" Override default gc[...] mappings
let g:tcomment_opleader1 = ''
" Default gc mappings that should be kept
nmap <silent> gc <Plug>TComment_gc
nmap <silent> gcb <Plug>TComment_gcb
xmap gc <Plug>TComment_gc
" Custom gc mappings
nmap <silent> gcc :TComment<CR>

" }}}

" AnsiEsc configuration {{{

" Remove unwanted mappings
augroup AnsiEsc_unmap_autocommands
    autocmd!
    autocmd VimEnter *
        \ execute 'nunmap <Leader>swp' |
        \ execute 'nunmap <Leader>rwp'
augroup END

" }}}

" vim-pipe-preview configuration {{{

" Preview markdown files using mdv with the "Marieke" color theme
let g:pipe_preview_markdown_command = 'mdv -t "960.847" -'
nnoremap <silent> <Leader>mn :<C-U>PipePreview<CR>
nnoremap <silent> <Leader>mu :<C-U>PipePreviewUpdate<CR>

" }}}

" vim-gutentags configuration {{{

if !executable('ctags')
    let g:gutentags_enabled = 0
endif
let g:gutentags_generate_on_new = 0
let g:gutentags_ctags_tagfile = '.tags'
let g:gutentags_project_root = ['.tags', 'tags']
let g:gutentags_file_list_command = {
    \ 'markers': {
        \ '.git': 'git ls-files -co --exclude-standard',
        \ '.hg': 'hg locate',
        \ },
    \ }
let g:gutentags_generate_on_empty_buffer = 1

" }}}

" ultisnips configuration {{{

let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsExpandTrigger="<c-j>"

" }}}

" Autocompletion configuration (jedi-vim and completor) {{{

let g:jedi#show_call_signatures_delay = 100
nnoremap <silent> <C-]> :call jedi#goto()<CR>

let g:completor_auto_trigger = 1

" From the completor README:
" https://github.com/maralla/completor.vim#use-tab-to-trigger-completion-disable-auto-trigger
function! Tab_Or_Complete() abort
    " If completor is already open the `tab` cycles through suggested completions.
    if pumvisible()
        return "\<C-N>"
        " If completor is not open and we are in the middle of typing a word then
        " `tab` opens completor menu.
    elseif col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
        return "\<C-R>=completor#do('complete')\<CR>"
    else
        " If we aren't typing a word and we press `tab` simply do the normal `tab`
        " action.
        return "\<Tab>"
    endif
endfunction
inoremap <expr> <Tab> Tab_Or_Complete()

" }}}

" vim: set fdls=0 fdm=marker:
