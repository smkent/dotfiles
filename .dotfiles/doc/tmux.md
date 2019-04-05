# Tmux configuration

This is a summary of the configuration in [`.tmux.conf`](/.tmux.conf).

![tmux screenshot](/.dotfiles/img/screenshot-tmux.png)

# Basic settings

* Enable 256-color support
* Set terminal emulator window titles
* Increase scrollback buffer size to 5000
* Enable automatic window renumbering
* Custom colors and status bar configuration
  * Window ID highlight inspired by [the screenshot in this
    thread](http://crunchbang.org/forums/viewtopic.php?id=20504)

# Key bindings

* `<Prefix>` is mapped to `Ctrl+a` (similar to GNU screen).
* The `mode-keys` option is set to `vi` to enable Vim-style key bindings.

`<Prefix>?` can be used to display the list of currently configured
key bindings.

## Normal mode

| Binding | Meaning |
| :-- | :-- |
| `Ctrl+F7` | Move to the previous session |
| `Ctrl+F8` | Move to the next session |
| `F7` | Move to the previous window |
| `F8` | Move to the next window |
| `<Prefix>A` | Rename current window |
| `<Prefix>e` | Select session from a list |
| `<Prefix>s` | Split current pane horizontally |
| `<Prefix>v` | Split current pane vertically |
| `<Prefix><` | Prompt for a window to swap the current window with |
| `<Prefix>>` | Swap the current and marked panes |
| `<Prefix>,` | Swap the current pane with the previous pane |
| `<Prefix>.` | Swap the current pane with the next pane |
| `<Prefix>/` | Enter copy mode |
| `<Prefix>Esc` | Enter copy mode |
| `<Prefix>H` | Create new full height vertical pane left |
| `<Prefix>J` | Create new full width horizontal pane below |
| `<Prefix>K` | Create new full width horizontal pane above |
| `<Prefix>L` | Create new full height vertical pane right |
| `Ctrl+h` | Move to pane left |
| `Ctrl+j` | Move to pane below |
| `Ctrl+k` | Move to pane above |
| `Ctrl+l` | Move to pane right, or clear screen if pane is full width |
| `<Prefix>h` | Move to pane left |
| `<Prefix>j` | Move to pane below |
| `<Prefix>k` | Move to pane above |
| `<Prefix>l` | Move to pane right |
| `<Prefix>Ctrl+a` | Move to the next pane |
| `Alt+<Arrow Keys>` | Resize the current pane in the specified direction |
| `<Prefix>r` | Reload [`.tmux.conf`](/.tmux.conf) |

Pane traversal with `Ctrl+[hjkl]` is from
[vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator)

## Copy mode

| Binding | Meaning |
| :-- | :-- |
| `/` | Search backward (up) |
| `?` | Search forward (down) |
| `v` | Begin selection |
| `y` | Copy selection (also to the system clipboard if `xclip` is installed) |
| `Escape` or `/` | Exit copy mode |
