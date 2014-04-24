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
match ExtraWhitespace /\s\+$/
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red

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
