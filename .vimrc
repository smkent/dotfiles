" Several basic settings and some mappings from https://github.com/gergap/vim
" Additional mappings from YADR: https://github.com/skwp/dotfiles

" Disable vi compatibility (emulation of old bugs)
set nocompatible

" set UTF-8 encoding
set enc=utf-8
set fenc=utf-8
set termencoding=utf-8

" Indentation settings
set autoindent      " Use indentation of previous line
set smartindent     " Use intelligent indentation for code

" Set tab width to 4
set tabstop=4
set shiftwidth=4
set expandtab       " Insert spaces instead of tabs
" Don't insert spaces instead of tabs in Makefiles
autocmd filetype make set noexpandtab
filetype indent plugin on

" Always start the cursor on the first line when editing a git commit message
" or editing interactive rebase instructions
" http://vim.wikia.com/wiki/VimTip1636
"
" Replace "pick" with "p" before editing interactive rebase instructions
autocmd filetype gitcommit call setpos('.', [0, 1, 1, 0])
autocmd filetype gitrebase :silent %s/^pick/p/g |
                         \ call setpos('.', [0, 1, 1, 0])

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

" Highlight trailing whitespace in red
" http://vim.wikia.com/wiki/VimTip396
au WinEnter * call matchadd('Error', '\s\+$', 4)
au BufWinEnter * call matchadd('Error', '\s\+$', 5)
if version >= 702
    au BufWinLeave * call clearmatches()
endif

" Highlight certain nonprintable characters
set list
set listchars=nbsp:¬,tab:»\ ,extends:»,precedes:«

set mouse=          " Disable mouse support
set so=8            " so is "Scrolloff", or the minimum number of context
                    " lines that are displayed above/below the cursor.

" Enable command line completion
set wildmenu
set wildmode=longest:full,full

" Set custom timeout exiting insert mode
" The default timeout is much higher, resulting in a delay exiting insert mode
set timeout timeoutlen=1000 ttimeoutlen=50

" Custom Keyboard mappings

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
nnoremap <F3> :noh<return><esc>

" F4: Toggle paste mode
set pastetoggle=<F4>
nnoremap <silent> <F4> :set paste!<CR>

" Navigate the location list using [l and ]l
nnoremap ]l :lnext<CR>
nnoremap [l :lprevious<CR>

" Remap record (q) to ,q so q can be used to quit vim
nnoremap <Leader>q q

" Remap Ctrl+e and Ctrl+y so they can be used elsewhere
nnoremap <Leader>e <C-e>
nnoremap <Leader>y <C-y>

" Paste from the system clipboard with ,p and ,P
nnoremap <Leader>p "+p
nnoremap <Leader>P "+Pl

" Surround shortcuts
map <Leader>' ysiw'
vmap <Leader>' c'<C-R>"'<ESC>
map <Leader>" ysiw"
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

" Confirm and quit using q in normal mode, or Ctrl+X in normal or insert modes
nnoremap q :conf q<cr>
inoremap <C-x> <esc>:conf q<cr>
nnoremap <C-x> :conf q<cr>

" Remap Q to save and quit. This also disables Ex mode.
nnoremap Q :wq<cr>

" Use ,W to save the current file with sudo
nnoremap <Leader>W :w !sudo tee > /dev/null %<CR>

" 80-character column highlight
" http://stackoverflow.com/a/3765575
if exists('+colorcolumn')
    set colorcolumn=81
else
    au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
endif

" Set current line number highlight color for use with relativenumber
" To use the same color as the rest of the line numbers, use:

" Disable vim requesting the terminal version
" This prevents extraneous garbage from being printed on startup
set t_RV=

" Plugin configuration

" Define list of plugins to be installed
silent call plug#begin()  " Suppress error message if git is not installed
Plug('https://github.com/christoomey/vim-tmux-navigator')
Plug('https://github.com/ctrlpvim/ctrlp.vim')
Plug('https://github.com/jeffkreeftmeijer/vim-numbertoggle')
Plug('https://github.com/scrooloose/syntastic')
Plug('https://github.com/tomtom/tcomment_vim')
Plug('https://github.com/tpope/vim-fugitive')
Plug('https://github.com/tpope/vim-surround')
Plug('https://github.com/vim-airline/vim-airline')
" vim-gitgutter with real-time sign updates enabled occasionally produced
" rendering errors prior to Vim 7.4.427. For more information, see:
" - https://github.com/airblade/vim-gitgutter/issues/171
" - http://ftp.vim.org/vim/patches/7.4/7.4.427
if executable('git')
    if has("patch-7.4.427")
        Plug('https://github.com/airblade/vim-gitgutter')
        " Reduce default refresh time from 4 seconds to 0.25 seconds
        set updatetime=250
    else
        Plug('https://github.com/mhinz/vim-signify')
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

" vim-airline configuration
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

" Customize right statusbar section contents
let g:airline_section_x = airline#section#create_right(
    \ ['tagbar', 'filetype', 'ffenc'])
let g:airline_section_y = airline#section#create(['%3p%%'])
let g:airline_section_z = airline#section#create(['linenr', ':%3c '])

" vim-signify configuration
let g:signify_vcs_list = [ 'git' ]

" Map [c and ]c shortcuts to jump between hunks
let g:signify_mapping_next_hunk = ']c'
let g:signify_mapping_prev_hunk = '[c'

" vim-signify integration with vim-airline
" Only show modified counts in the status bar if they're non zero
let g:airline#extensions#hunks#non_zero_only = 1

" vim-gitgutter configuration
" Customize sign characters
let g:gitgutter_highlight_lines = 1
let g:gitgutter_sign_removed = '< '
let g:gitgutter_sign_removed_first_line = '^^'
let g:gitgutter_sign_modified_removed = '~!'

" Customize sign column highlight
" Highlight groups are located in my color scheme file
" See the section "Plugin highlight groups" in that file
let g:gitgutter_override_sign_column_highlight = 0

" ctrlp configuration
let g:ctrlp_map = '<c-p>'
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
nnoremap <C-e> :CtrlPBuffer<CR>

" syntastic configuration
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
" syntastic file type specific configuration
let g:syntastic_python_checkers = ['flake8', 'python']

" tcomment configuration
"
" By default, tcomment's gcc mapping uses the count to repeat the comment
" instead of commenting out the specified number of lines. This configuration
" uses the count with gcc to toggle comments for the specified number of
" lines instead.
" https://github.com/tomtom/tcomment_vim/issues/105
"
" Override default gc[...] mappings
let g:tcommentMapLeaderOp1 = ''
" Default gc mappings that should be kept
nmap <silent> gc <Plug>TComment_gc
nmap <silent> gcb <Plug>TComment_gcb
xmap gc <Plug>TComment_gc
" Custom gc mappings
nmap <silent> gcc :TComment<CR>
