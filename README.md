# smkent's dotfiles

My Linux environment configuration

## Design

My dotfiles are designed to be:
* Portable with minimal dependencies (git, bash, and Python).
* Easy to set up and use. This repository can simply be cloned to `$HOME`. [See
below for installation](#installation).

Most of my dotfiles are in the top level of the repository, but a few others
are located in [`.dotfiles/templates/`](/.dotfiles/templates/). These templates
are typically files that are modified on a machine during normal use (e.g.
[`.ssh/config`](/.dotfiles/templates/ssh/config_append)). Templates are
organized into subdirectories, each with its own `install` script that may
perform arbitrary installation actions.

Template installation happens when a new login shell is started and any of the
template files are newer than the previous template installation timestamp.
Template installation may also happen manually by running
[`expand-dotfiles -f`](/.dotfiles/bin/expand-dotfiles).

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

Next, run `git status` and review any differences you may want to keep. Then,
install the cloned dotfiles with:

```shell
$ git checkout .
```

If you use or fork this repository, you'll want to update `.gitconfig` with
your name and email address and remove `.face`.

### External components

My [vim-airline](https://github.com/vim-airline/vim-airline) and tmux
configurations require the [Powerline
Fonts](https://github.com/powerline/fonts), which can be installed using the
[install-fonts](/.dotfiles/bin/install-fonts) script.

## Features

### Bash

* Display exit code of the previous command if nonzero (or "bg" / "C-c" when
backgrounding a job or typing Ctrl-C, respectively)
* Display runtime of the previous command if longer than 10 seconds
* Display size of the directory stack if not empty
* Display git branch (or hash on detached HEAD) if the current directory is a
git repository
* Display number of background jobs if any

![bash screenshot](/.dotfiles/img/screenshot-bashrc.png)

### Tmux

* Use Ctrl-A as the prefix key (similar to GNU screen)
* Some vim-style key mappings:
  * Ctrl+A h/j/k/l for traversing panes
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
* Save files by pressing F2
* Confirm changes and quit vim using `q` in normal mode, or Ctrl+X in normal or
insert modes
* Highlight 81st column (requires Vim 7.3+)
* Custom [vim-airline](https://github.com/vim-airline/vim-airline) color scheme

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
* `git grep`: Maches in orange, matching filenames in purple, line numbers in
brighter green, function names in yellow, and separators in gray
* `git status`: Branch name in bold and underlined, added files in brighter
green, changed files in brighter red, files with conflicts in yellow, and
untracked files in blue

![git colors screenshot](/.dotfiles/img/screenshot-git-colors.png)

#### Aliases

See my [.gitconfig](/.gitconfig) for the full list of aliases. Some of the
more useful aliases are:

* `ca`: "commit amend" (`git commit --amend`)
* `cb`: "create branch" (Creates a new branch at either the specified point or
current HEAD, copying remote tracking branch information if available)
* `cf`: "commit fixup" (`git commit --amend --no-edit`)
* `ds`: "diff staged" (`git diff --staged`)
* `dw`: "word diff" (`git diff --word-diff=color`)
* `fa`: "find alias," based on [the "finda" alias from
here](http://brettterpstra.com/2014/08/04/shell-tricks-one-git-alias-to-rule-them-all/)
(Type "git fa" followed by an optional grep term to see all configured aliases,
or aliases matching the specified search term)
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
* `ri`: "rebase interactive" (Specify either a base commit or number of commits
to rebase, e.g. `git ri @~3` or `git ri 3`)
* `rn`: "rebase new" (`git rebase -i`; Starts an interactive rebase for all
commits not on the current branch's remote tracking branch)
* `ub`: "upstream branch" (Shows the output of `git show-branch` for the
current branch and its upstream tracking branch)
