# smkent's dotfiles

My Linux environment configuration

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

## Additional dependencies

My vim-airline configuration requires the
[Powerline Fonts](https://github.com/powerline/fonts), which can be installed
using the [install-fonts](/.dotfiles/bin/install-fonts) script.

## Features

### .bashrc

* Display exit code of the previous command if nonzero (or "bg" / "C-c" when
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

### Git

#### Basic settings

* Use `less` with 4-column tab stops
* Set push default to `upstream`
* Enable `diff3` conflict resolution style
* Disable `git status` hints
* Enable rename and copy detection by default
* Enable mnemonic prefixes in `git diff`

#### Custom colors

* `git branch`: Remote branches in lighter red, upstream branches in blue bold
* `--decorate` (with `git log`, etc.): HEAD in red bold, remote branches in
blue bold, tags in yellow bold
* `git diff`: Hunk header (line numbers changed) in blue bold, hunk function
header in magenta bold
* `git grep`: Several customizations, mostly to colorize matching file names
(in magenta). See the `[color "grep"]` section in [.gitconfig](/.gitconfig) for
the full details.
* `git status`: Branch name in bold and underlined, changed files in brighter
red, files with conflicts in yellow, and untracked files in blue

#### Aliases

Some of the useful aliases I have defined are:

* `ca`: "commit amend" (`git commit --amend`)
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
* `ri`: "rebase interactive" (specify either a base commit or number of commits
to rebase, e.g. `git ri @~3` or `git ri 3`)
* `ub`: "upstream branch" (shows the output of `git show-branch` for the
current branch and its upstream tracking branch)
