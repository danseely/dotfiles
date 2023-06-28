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

- [x] add `vimrc`
- [ ] add `tmuxrc`
- [ ] figure out correct portable config for oh-my-zsh
- [ ] figure out correct portable config for fzf
- [ ] figure out correct portable config for iterm
- [ ] figure out correct portable config for atext
