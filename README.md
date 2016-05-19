# smkent's dotfiles

My Linux environment configuration

## Installation

I recommend looking at the code and trying out individual parts you are
interested in before installing the entire set of dotfiles.

To install these dotfiles in your home directory, run:

```shell
git clone https://github.com/smkent/dotfiles
mv dotfiles/.git .
git checkout .
```

You should run `git status` and review any differences before running
`git checkout .`

If you use or fork this repository, you'll want to update `.gitconfig` with
your name and email address and remove `.face`.

## Additional dependencies

My vim-airline configuration requires the
[Powerline Fonts](https://github.com/powerline/fonts).

## Features

### .bashrc

* Display exit code of the previous command if nonzero (or "bg" / "C-C" when
backgrounding a job or typing Ctrl-C, respectively)
* Display runtime of the previous command if longer than 10 seconds
* Display size of the directory stack if not empty
* Display git branch (or hash on detached HEAD) if the current directory is a
git repository
* Display number of background jobs if any

![screenshot of .bashrc in action](/.dotfiles/img/screenshot-bashrc.png)

### .vimrc

* The usual basic settings (line numbers, syntax highlighting, etc.)
* Save files by pressing F2
* Highlight 81st column (requires Vim 7.3+)
* Custom [vim-airline](https://github.com/vim-airline/vim-airline) color scheme

![vim screenshot](/.dotfiles/img/screenshot-vim.png)
