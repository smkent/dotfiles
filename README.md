# smkent's dotfiles

My Linux environment configuration

## Design

Most of this repository contains flat files meant to be used in place within
`${HOME}`. A few others are organized under
[`.dotfiles/templates/`](/.dotfiles/templates/), which are typically files that
are modified during normal use (e.g.
[`.ssh/config`](/.dotfiles/templates/ssh/config_append)). Templates are
installed when a new login shell is started and any of the template files are
newer than the previous template installation timestamp, or when
[`expand-dotfiles -f`](/.dotfiles/bin/expand-dotfiles) is run manually.

My dotfiles are designed be portable with minimal dependencies (git, bash,
Python, and the [Powerline fonts](https://github.com/powerline/fonts)).

## Installation

I recommend looking at the code and trying out individual parts you are
interested in before installing the entire set of dotfiles.

To install these dotfiles in your home directory, first clone the repository:

```shell
$ cd ~
$ git clone https://github.com/smkent/dotfiles
$ mv dotfiles/.git .
$ rm -rf dotfiles/
```

Next, review changes to any existing dotfiles using `git status` and `git diff`.
When satisfied, complete installation with:

```shell
$ git checkout .
```

### Configuration

When installing or forking this repository, you should:

* Update [`.gitconfig`](/.gitconfig) with your name and email address
* Set `prompt_hide_user` to your username in [`.bashrc`](/.bashrc)
* Remove or replace `.face`

### Dependency installation

My [vim-airline](https://github.com/vim-airline/vim-airline) and
[tmux](https://github.com/tmux/tmux) configurations require the [Powerline
fonts](https://github.com/powerline/fonts), which can be installed using
[install-fonts](/.dotfiles/bin/install-fonts) after installing this repository.

## Features

### Bash

* Display username if different from the value of `prompt_hide_user` in
  [.bashrc](/.bashrc)
* Display current directory name if different from `${HOME}`
* Display exit code of the previous command if nonzero (or "bg" / "C-c" when
  backgrounding a job or typing Ctrl-C, respectively)
* Display runtime of the previous command if longer than 10 seconds
* Display size of the directory stack if not empty
* Display number of background jobs if any
* Display git branch (or hash on detached HEAD) if the current directory is a
  git repository

![bash screenshot](/.dotfiles/img/screenshot-bashrc.png)

### Tmux

* Use Ctrl-A as the prefix key (similar to GNU screen)
* Use vi-style mode keys
* Additional vim-style key mappings:
  * Ctrl+h/j/k/l for traversing panes (using
    [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator))
  * Create window splits with Ctrl+A s (horizontal) or Ctrl+A v (vertical)
* Move between windows with F7/F8
* Alt+&lt;arrow keys&gt; for resizing panes
* Custom status bar configuration
  * Window ID highlight inspired by [the screenshot in this
    thread](http://crunchbang.org/forums/viewtopic.php?id=20504)
* Bash helper aliases:
  * `tn`: New session. Takes an optional session name argument.
  * `ta`: Attach to session. Takes an optional session name argument.
  * `tl`: List sessions.

![tmux screenshot](/.dotfiles/img/screenshot-tmux.png)

### Vim

* The usual basic settings (line numbers, syntax highlighting, etc.)
* Save files by pressing F2 or Ctrl+S, or save and quit with `Q` in normal mode
* Confirm changes and quit vim using `q` in normal mode, or Ctrl+X in normal or
  insert modes
* Highlight 81st column (requires Vim 7.3+)
* Custom [vim-airline](https://github.com/vim-airline/vim-airline) color scheme
* Some basic and [vim-surround](https://github.com/tpope/vim-surround) keymaps
  from [YADR (Yet Another Dotfile Repo)](https://github.com/skwp/dotfiles/)

![vim screenshot](/.dotfiles/img/screenshot-vim.png)

### Git

#### Basic settings

* Use `less` with 4-column tab stops
* Set push default to `upstream`
* Enable `diff3` conflict resolution style
* Disable `git status` hints
* Enable rename and copy detection by default
* Enable mnemonic prefixes in `git diff`

#### Custom colors

* `git branch`: Remote branches in brighter red, upstream branches in blue bold
* `--decorate` (with `git log`, etc.): HEAD in red bold, remote branches in
  blue bold, tags in yellow bold
* `git diff`: Brighter green and red for added and removed, hunk header (line
  numbers changed) in brighter blue bold, hunk function header in magenta bold
* `git grep`: Matches in orange, matching filenames in purple, line numbers in
  brighter green, function names in yellow, and separators in gray
* `git status`: Branch name in bold and underlined, added files in brighter
  green, changed files in brighter red, files with conflicts in yellow, and
  untracked files in blue

![git colors screenshot](/.dotfiles/img/screenshot-git-colors.png)

#### Aliases

See my [.gitconfig](/.gitconfig) for the full list of aliases. Some of the more
useful aliases are:

* `ca`: "commit amend" (`git commit --amend`)
* `cb`: "create branch" (Creates a new branch at either the specified point or
  current HEAD, copying remote tracking branch information if available)
* `cf`: "commit fixup" (`git commit --amend --no-edit`)
* `ds`: "diff staged" (`git diff --staged`)
* `dw`: "word diff" (`git diff --word-diff=color`)
* `fa`: "find alias," based on [the "finda" alias from
  here](http://brettterpstra.com/2014/08/04/shell-tricks-one-git-alias-to-rule-them-all/)
  (Type "git fa" followed by an optional grep term to see all configured
  aliases, or aliases matching the specified search term)
* log aliases:
  * `l`: "log" (Similar to basic `git log`, but with extra colors, commit date
    and relative date instead of author date)
  * `lc`: "log compact" (Log format with commit and metadata on one line
    followed by full commit messages)
  * `lf`: "log files" (One line per commit followed by the changed file list
    produced by `--numstat`)
  * `lo`: "log oneline" (One line per commit, with the relative commit date on
    the left)
  * `lx`: "log eXtra" (Similar to the `l` alias, but with both author and
    committer information)
* `ri`: "rebase interactive" (Specify a base commit, number of commits such as
  `git ri 3`, or no argument to rebase all commits on on the current branch's
  remote tracking branch)
* `ub`: "upstream branch" (Shows the output of `git show-branch` for the
  current branch and its upstream tracking branch)
