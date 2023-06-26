parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

 if [ -f ~/.git-completion.bash ]; then
   . ~/.git-completion.bash
 fi

if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

#PS1="\W > "
# http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/x329.html
export PS1="\[\033[1;34m\]\w \T \[\033[36m\]\$(parse_git_branch)\[\033[00m\] \n> "

export NVM_DIR="$HOME/.nvm"
 . "/usr/local/opt/nvm/nvm.sh"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

# meta
alias spr="source ~/.bash_profile" 

# fshow - git commit browser (enter for show, ctrl-d for diff, ` toggles sort)
# via https://junegunn.kr/2015/03/browsing-git-commits-with-fzf/
fshow() {
  local out shas sha q k
  while out=$(
      git log --graph --color=always \
          --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
      fzf --ansi --multi --no-sort --reverse --query="$q" \
          --print-query --expect=ctrl-d --toggle-sort=\`); do
    q=$(head -1 <<< "$out")
    k=$(head -2 <<< "$out" | tail -1)
    shas=$(sed '1,2d;s/^[^a-z0-9]*//;/^$/d' <<< "$out" | awk '{print $1}')
    [ -z "$shas" ] && continue
    if [ "$k" = ctrl-d ]; then
      git diff --color=always $shas | less -R
    else
      for sha in $shas; do
        git show --color=always $sha | less -R
      done
    fi
  done
}

alias ddp="cd ~/Dropbox/"
alias vvup="vagrant up"
alias vvh="vagrant halt"
alias vvs="vagrant ssh"
alias vvu="vagrant up"
alias yt="youtube-dl"
alias note="cd ~/Dropbox/Apps/Byword && vim"
alias fixnode="nvm use 8 && nvm alias default 8"

alias sshpi="ssh -p 42038 pi@192.168.1.19"
alias sshpirem="ssh -p 42038 pi@ablate-guardian.ddns.net"

alias killdups='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user;killall Finder;echo "Rebuilt Open With, relaunching Finder"'
test -e "${HOME}/.iterm3_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
alias weather="curl http://wttr.in"
alias ttmx="tmux new-session -s"
alias ttma="tmux attach-session -t "
alias ttml="tmux list-sessions"
alias ttmk="tmux kill-session -t "
alias ttmch="cat ~/.tmux-cheatsheet"

# re-apply Slack dark mode after update
alias fixslack='python ~/dev/fixslack.py'

# launching slack
alias slackn="slack-term -config ~/slack-term-nutshell.json"

# AWS cli auth script
# Usage: `awsauth <mfa token code>
alias awsauth="~/aws-auth.sh default "

# git stuff
alias pairas="git config user.pair 'AS+DS' && git config user.name 'Andrew Sardone and Dan Seely' && git config user.email 'developers+dseely+asardone@nutshell.com'; pair"
alias paircb="git config user.pair 'DS+CB' && git config user.name 'Dan Seely and Chris Berger' && git config user.email 'developers+dseely+cberger@nutshell.com'; pair"
alias unpair="git config --remove-section user 2> /dev/null; echo Unpaired.; pair"
alias pair='echo "Committing as: `git config user.name` <`git config user.email`>"'
alias aws-nut-ec2='aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" --query ''Reservations[*].Instances[*].[Tags[?Key==`Name`] | [0].Value,InstanceId,InstanceType,PrivateIpAddress]'' --output table'
alias ctags="`brew --prefix`/bin/ctags"
alias yis="yarn install && yarn clientBuild"
alias gs="git status"
alias gitx="open -a GitX ."
alias cgd="alias cgd='cd $(gd=$(git rev-parse --git-dir); echo ${gd%.git*}./)’"
alias gitprune='git branch --merged | egrep -v "(^\*|master|dev)" | xargs git branch -d'

## Vim / NeoVim
alias nv="nvim"
#alias vim="nvim"
alias vimrc="vim ~/.vim/vimrc"
export PATH="/usr/local/sbin:$PATH"
# eval "$(pyenv init -)"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Adadapted aliases
alias sandboxssh="ssh ubuntu@34.229.169.195 -i ~/.ssh/aasand.pem"
alias prodssh="ssh ubuntu@3.88.91.142 -i ~/.ssh/aaprod.pem"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/dan/dev/google-cloud-sdk/path.bash.inc' ]; then . '/Users/dan/dev/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/dan/dev/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/dan/dev/google-cloud-sdk/completion.bash.inc'; fi

# pyenv
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
. "$HOME/.cargo/env"
