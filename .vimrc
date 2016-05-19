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

set hlsearch        " Highlight search results
set incsearch       " Show search matches as you type

" Color settings
set t_Co=256        " Enable 256 colors
syntax on           " Enable syntax highlighting
colorscheme smkent256

set number          " Show line numbers
set showmatch       " Show matching braces

set nowrap          " Don't wrap long lines

" Highlight trailing whitespace in red
highlight ExtraWhitespace ctermbg=red guibg=red
au WinEnter * call matchadd('ExtraWhitespace', '\s\+$', 4)
au BufWinEnter * call matchadd('ExtraWhitespace', '\s\+$', 5)
if version >= 702
    au BufWinLeave * call clearmatches()
endif

" Highlight certain nonprintable characters
set list
set listchars=nbsp:¬,tab:»\ ,extends:»,precedes:«
hi SpecialKey ctermfg=red

set mouse=a         " Enable mouse support (and scroll wheel)
set so=8            " so is "Scrolloff", or the minimum number of context
                    " lines that are displayed above/below the cursor.

" Enable command line completion
set wildmenu
set wildmode=longest:full,full

" Set custom timeout exiting insert mode
" The default timeout is much higher, resulting in a delay exiting insert mode
set timeout timeoutlen=1000 ttimeoutlen=50

" Custom Keyboard mappings

" F2: In normal mode, save the file
"     In insert mode, exit insert mode, save the file, and enter insert mode
nmap <F2> :w<CR>
imap <F2> <ESC>:w<CR>i

" F3: Clear last search highlighting
nnoremap <F3> :noh<return><esc>

" F4: Toggle paste mode
set pastetoggle=<F4>

" Ctrl+[H|J|K|L]: Move between vim splits
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l

" Disable Ex Mode
nnoremap Q <nop>

" 80-character column highlight
" http://stackoverflow.com/a/3765575
if exists('+colorcolumn')
    set colorcolumn=81
    highlight ColorColumn ctermbg=236
else
    au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
endif

" Plugin configuration

" Define list of plugins to be installed
call plug#begin()
Plug('https://github.com/mhinz/vim-signify/')
Plug('https://github.com/vim-airline/vim-airline')
call plug#end()

" Install plugins automatically if needed and if VIM_SKIP_PLUGINS is unset or 0
if empty($VIM_SKIP_PLUGINS) || $VIM_SKIP_PLUGINS == 0
    if !empty(filter(copy(g:plugs), '!isdirectory(v:val.dir)'))
        PlugInstall | q
    endif
endif

" vim-airline configuration
set laststatus=2    " Always show the status bar

" Enable powerline fonts if vim is running locally, or if VIM_AIRLINE is set
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

" Set Sy sign colors
highlight SignifySignAdd    cterm=bold ctermbg=233  ctermfg=119
highlight SignifySignDelete cterm=bold ctermbg=233  ctermfg=167
highlight SignifySignChange cterm=bold ctermbg=233  ctermfg=227

" Map [c and ]c shortcuts to jump between hunks
let g:signify_mapping_next_hunk = ']c'
let g:signify_mapping_prev_hunk = '[c'

" vim-signify integration with vim-airline
" Only show modified counts in the status bar if they're non zero
let g:airline#extensions#hunks#non_zero_only = 1
