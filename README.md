## Usage (still wip)

Manually craete ssh key, then add it (`~/.ssh/id_rsa.pub`) to Github & Gitlab accounts

```
cd ~
ssh-keygen -t rsa -b 2048
```

clone repo

```
git clone git@github.com:danseely/dotfiles.git .dotfiles
cd .dotfiles
```

add symlinks in `~`

```
~/.gitconfig -> /Users/dan/.dotfiles/.gitconfig
~/.bash_profile -> /Users/dan/.dotfiles/.bash_profile
~/.zshrc -> /Users/dan/.dotfiles/.zshrc
~/.config/karabiner -> /Users/dan/.dotfiles/karabiner
```

run setup

```
$ sh ./osx.sh
```

## High-level todos

- [ ] add `vimrc`
- [ ] add `bash_profile`
- [ ] add `tmuxrc`
- [ ] replace `vimrc`, `bash_profile`, `tmuxrc` on Mac with symlinks
- [ ] https://github.com/jasonrudolph/keyboard (Hammerspoon + Karabiner)

## Automate intsalls

- [ ] vagrant
- [ ] virtualbox
- [ ] PHPStorm
- [ ] MAS apps

## Changes

- [ ] get PHPSTorm config into dotfiles, out of built-in sync
