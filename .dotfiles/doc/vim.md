# Vim configuration

This is a summary of the configuration in [`.vimrc`](/.vimrc).

![vim screenshot](/.dotfiles/img/screenshot-vim.png)

# Basic settings

* Disable vi compatibility (`nocompatible`)
* Enable UTF-8 support (via `enc`, `fenc`, and `termencoding`)
* Automatic indentation (`autoindent` and `smartindent`)
* 4-character tab width (`tabstop`, `softtabstop`, `shiftwidth` set to 4)
* Insert spaces by default (`expandtab`)
* Highlight searches (`hlsearch` and `incsearch`)
* Syntax highlighting, 256-color support, and [custom color
  scheme](/.vim/colors/smkent.vim) (via `syntax` and `t_Co`)
* Show relative line numbers (`number` and `relativenumber`)
* Show matching braces (`showmatch`)
* Don't wrap lines (`nowrap`)
* Highlight trailing whitespace and nonprintable characters (via `list` and
  `listchars`)
* Disable mouse support
* Set scrolloff to 2 (via `scrolloff`)
* Enable command line completion (via `wildmenu` and `wildmode`)
* Highlight 81st column (via `colorcolumn`)
* Open help windows vertically if space permits

## File type specific settings

* `make`: Insert tabs (`noexpandtabs`)
* `markdown`: Enable
  [vim-pipe-preview](https://github.com/smkent/vim-pipe-preview) using
  [terminal_markdown_viewer](https://github.com/axiros/terminal_markdown_viewer)
* `gitcommit`: Enable spell checking
* `gitrebase`: Abbreviate instances of `pick` to `p` on startup

# Plugins

Managed by [vim-plug](https://github.com/junegunn/vim-plug)

* [ALE](https://github.com/w0rp/ale)
* [AnsiEsc](https://github.com/vim-scripts/AnsiEsc.vim)
* [ctrlp.vim](https://github.com/ctrlpvim/ctrlp.vim)
* [tcomment_vim](https://github.com/tomtom/tcomment_vim)
* [vim-airline](https://github.com/vim-airline/vim-airline)
* [vim-fugitive](https://github.com/tpope/vim-fugitive)
* [vim-gitgutter](https://github.com/airblade/vim-gitgutter) (if [vim patch
  7.4.427](http://ftp.vim.org/vim/patches/7.4/7.4.427) is installed)
* [vim-gutentags](https://github.com/ludovicchabant/vim-gutentags)
* [vim-numbertoggle](https://github.com/jeffkreeftmeijer/vim-numbertoggle)
* [vim-pipe-preview](https://github.com/smkent/vim-pipe-preview)
* [vim-python-pep8-indent](https://github.com/hynek/vim-python-pep8-indent)
* [vim-signify](https://github.com/mhinz/vim-signify) (if vim patch 7.4.427 is
  not installed)
* [vim-surround](https://github.com/tpope/vim-surround)
* [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator)
* [vim-yaml](https://github.com/stephpy/vim-yaml)

# Mappings

Unless otherwise specified, listed mappings are available in normal mode.

## Default mapping overrides

[A chart of default vim mappings is available
here.](http://michael.peopleofhonoronly.com/vim/)

| Mapping | Meaning |
| :-- | :-- |
| `0` | Move to the first non-blank character of the line (`^`) |
| `^` | Move to the first character of the line (`0`) |
| `q` | Confirm and quit (`:conf q`) |
| `Q` | Save and quit (`:wq`) |
| `Ctrl+e` | Open CtrlP in find buffer mode (`:CtrlPBuffer`) |
| `Ctrl+y` | Toggle ALE verbosity |

## Additional mappings

`<Leader>` is mapped to `,`.

### General functions and toggles

| Mapping | Meaning |
| :-- | :-- |
| `F2`, `Ctrl+s` | Save the current buffer (`:w`) (normal and insert modes) |
| `F3` | Clear last search highlight (`:noh`) |
| `F4` | Toggle paste mode (`:set paste!`) |
| `F9` | Toggle spell checking (`:setlocal spell!`) |
| `<Leader>f` | Show the current buffer name |
| `<Leader>F` | Show the current buffer's absolute path |
| `<Leader>W` | Save the current buffer with sudo |
| `<Leader>p` | Paste from the system clipboard after the cursor |
| `<Leader>P` | Paste from the system clipboard before the cursor |
| `<Leader>.` | Redraw the screen |

### Remapped default mappings

| Mapping | Meaning |
| :-- | :-- |
| `<Leader>q` | Record (`q`) |
| `<Leader>e` | Scroll window down in the buffer (`Ctrl+e`) |
| `<Leader>y` | Scroll window up in the buffer (`Ctrl+y`) |

### Window management

| Mapping | Meaning |
| :-- | :-- |
| `Ctrl+Up` | Decrease current window height |
| `Ctrl+Down` | Increase current window height |
| `Ctrl+Left` | Decrease current window width |
| `Ctrl+Right` | Increase current window width |
| `Ctrl+w h` | Create new vertical split spanning left side of screen |
| `Ctrl+w j` | Create new horizontal split spanning bottom of screen |
| `Ctrl+w k` | Create new horizontal split spanning top of screen |
| `Ctrl+w l` | Create new vertical split spanning right side of screen |

### Navigation

| Mapping | Meaning |
| :-- | :-- |
| `[c` | Move to previous git hunk (change) |
| `]c` | Move to next git hunk (change) |
| `[l` | Move to previous location list item |
| `]l` | Move to next location list item |
| `[L` | Move to first location list item (`:lfirst`) |
| `]L` | Move to last location list item (`:llast`) |
| `[n` | Move to previous SCM conflict marker (normal and operator modes) |
| `]n` | Move to next SCM conflict marker (normal and operator modes) |
| `[t` | Move to previous matching tag (`:tprevious`) |
| `]t` | Move to next matching tag (`:tnext`) |
| `[T` | Move to first matching tag (`:tfirst`) |
| `]T` | Move to last matching tag (`:tlast`) |

### CtrlP plugin mappings

| Mapping | Meaning |
| :-- | :-- |
| `Ctrl+p` | Open CtrlP in mixed mode (`:CtrlPMixed`) |
| `Ctrl+e` | Open CtrlP in find buffer mode (`:CtrlPBuffer`) |
| `Ctrl+2` | Open CtrlP in tag mode (`:CtrlPTag`) |

### ALE plugin mappings

| Mapping | Meaning |
| :-- | :-- |
| `<Leader>l` | Toggle location list |
| `Ctrl+y` | Toggle ALE verbosity (default mapping override) |
| `<Leader>d` | Toggle ALE |

### tcomment plugin mappings

| Mapping | Meaning |
| :-- | :-- |
| `gc<motion>` | Toggle comment across `<motion>` |
| `gc` | Toggle comment (visual and select modes) |
| `gcb<motion>` | Toggle block comment across `<motion>` |
| `<count>gcc` | Toggle comment for the current line (or `<count>` lines) |

### vim-surround plugin mappings

Several of these mappings are from [YADR (Yet Another Dotfile
Repo)](https://github.com/skwp/dotfiles/)

| Mapping | Meaning |
| :-- | :-- |
| `<Leader>'` | Surround WORD with `'` (normal and visual modes) |
| `<Leader>"` | Surround WORD with `'` (normal and visual modes) |
| ``<Leader>` `` | Surround word with `` ` `` (normal and visual modes) |
| `<Leader>(` | Surround word with `()` plus spaces (normal and visual modes) |
| `<Leader>)` | Surround word with `()` (normal and visual modes) |
| `<Leader>[` | Surround word with `[]` plus spaces (normal and visual modes) |
| `<Leader>]` | Surround word with `[]` (normal and visual modes) |
| `<Leader>{` | Surround word with `{}` plus spaces (normal and visual modes) |
| `<Leader>}` | Surround word with `{}` (normal and visual modes) |
| `<Leader>r'` | Delete `'` contents under cursor and enter insert mode |
| `<Leader>r"` | Delete `"` contents under cursor and enter insert mode |
| ``<Leader>r` `` | Delete `` ` `` contents under cursor and enter insert mode |
| `<Leader>r(` | Delete next `()` contents and enter insert mode |
| `<Leader>r)` | Delete `()` contents under cursor and enter insert mode |
| `<Leader>r[` | Delete next `[]` contents and enter insert mode |
| `<Leader>r]` | Delete `[]` contents under cursor and enter insert mode |
| `<Leader>r{` | Delete next `{}` contents and enter insert mode |
| `<Leader>r}` | Delete `{}` contents under cursor and enter insert mode |

### vim-pipe-preview plugin mappings

| Mapping | Meaning |
| :-- | :-- |
| `<Leader>mn` | Open preview window for the current buffer |
| `<Leader>mu` | Update preview window for the current buffer |

### Miscellaneous mappings

| Mapping | Meaning |
| :-- | :-- |
| `[<Space>` | Insert `count` blank lines above the cursor |
| `]<Space>` | Insert `count` blank lines below the cursor |
| `<Leader>s` | Break current line at cursor (opposite of sorts to `J`) |
