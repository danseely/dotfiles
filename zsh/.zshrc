# vvv BEGIN VS Code / Cursor agent fix vvv
# https://forum.cursor.com/t/guide-fix-cursor-agent-terminal-hangs-caused-by-zshrc/107261
if [[ "$PAGER" == "head -n 10000 | cat" || "$COMPOSER_NO_INTERACTION" == "1" ]]; then
  return
fi

# Hopefully this one isn't needed, breaks in-IDE terminal
# if [[ "$TERM_PROGRAM" == "vscode" || "$TERM_PROGRAM" == "cursor" ]]; then
#   return
# fi

# ^^^ END VS Code / Cursor agent fix ^^^

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# Note: /opt/homebrew/{bin,sbin} are prepended by .zprofile via brew shellenv;
# do NOT re-add /usr/local/(s)bin here — that puts Intel Homebrew ahead on
# Apple Silicon and shadows arm64 binaries.
export PATH="$HOME/bin:$PATH"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# pyenv — guard the init evals so a machine without pyenv installed doesn't
# blow up the shell (e.g., the Pass 1 advance regression mode).
export PYENV_ROOT="$HOME/.pyenv"
[[ -n "$PYENV_ROOT" && -d "$PYENV_ROOT/bin" ]] && export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv >/dev/null 2>&1; then
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
fi

# poetry
export PATH="$HOME/.local/bin:$PATH"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="robbyrussell"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git docker docker-compose z history-substring-search)

# disable something about insecure something, idk (Dan)
ZSH_DISABLE_COMPFIX="true"

source $ZSH/oh-my-zsh.sh
fpath=(~/.zsh $fpath)
zstyle ':completion:*:*:git:*' script ~/.git-completion.bash

# history-substring-search keybindings — plugin must be loaded (above) before
# these bindkey calls. Without bindkey the plugin is dead weight.
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias vim="nvim"

# Codex CLI: inline mode (no alt-screen) so iTerm2 scrollback retains history.
alias codex-inline='command codex --no-alt-screen'

# AWS cli auth script
# Usage: `awsauth <mfa token code>
alias awsauth="~/aws-auth.sh default "

# git
alias gs="git status"
alias gitprune='git branch --merged | egrep -v "(^\*|master|dev)" | xargs git branch -d'

# brew
alias buu='brew update && brew upgrade'

# use newer fork of youtube-dl
# alias youtube-dl="yt-dlp"

# iTerm2 shell integration — must be sourced BEFORE p10k so its precmd/preexec
# hooks register before p10k's prompt initialization. iTerm's installer
# documents this requirement explicitly.
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# set GPG tty
export GPG_TTY=$TTY

# random
alias weather="curl http://wttr.in"

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/google-cloud-sdk/completion.zsh.inc"; fi

# NVM — eager source. Replaces the older zsh-nvm oh-my-zsh plugin (which was
# lazy but had its own issues). If startup latency becomes a problem we can
# revisit lazy strategies (e.g., zsh-defer) — current cost ~300ms cold.
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Per-pane iTerm2 theme switcher. Emits OSC 1337 SetProfile=<name> to switch
# the current session to a dynamic-profile clone of Default with only the bg
# overridden. `theme off` switches back to Default — a true reset that
# restores every profile attribute (transparency, dimming, all of it) because
# iTerm re-applies the full profile on switch.
#
# Profile definitions live in:
#   ~/Library/Application Support/iTerm2/DynamicProfiles/theme-profiles.json
theme() {
  local profile
  case "$1" in
    lavender|sage|slate|amber|crimson) profile="theme-$1" ;;
    off|reset)                          profile="Default" ;;
    ""|-h|--help|help|list|ls)
      cat <<EOF
usage: theme <name>

themes: lavender  sage  slate  amber  crimson
reset:  off  (alias: reset)
EOF
      return 0 ;;
    *) echo "theme: unknown '$1' — run 'theme' for the list" >&2; return 1 ;;
  esac
  # Fast path: TTY available — emit OSC directly. RestoreDefaultColors
  # clears any lingering session-level SetColors overrides (e.g. from a
  # prior `theme` version or anything else that scribbled on this session)
  # so the profile switch lands cleanly.
  if [[ -t 1 ]]; then
    printf '\033]1337;RestoreDefaultColors\007\033]1337;SetProfile=%s\007' "$profile"
    return 0
  fi
  # Fallback: no TTY (Claude Code's `!`-prefix captures stdout). Inject via
  # the iterm2 Python API, addressing this session by $ITERM_SESSION_ID.
  if [[ -z "$ITERM_SESSION_ID" ]]; then
    echo "theme: no TTY and ITERM_SESSION_ID unset — can't switch" >&2
    return 1
  fi
  /usr/bin/python3 - "$profile" <<'PYEOF' 2>/dev/null
import os, sys, iterm2
uuid = os.environ["ITERM_SESSION_ID"].split(":")[-1]
profile = sys.argv[1]
async def main(conn):
    app = await iterm2.async_get_app(conn)
    sess = app.get_session_by_id(uuid)
    if sess is None:
        print(f"theme: iterm session {uuid} not found", file=sys.stderr)
        sys.exit(1)
    await sess.async_inject(b"\x1b]1337;RestoreDefaultColors\x07")
    await sess.async_inject(f"\x1b]1337;SetProfile={profile}\x07".encode())
iterm2.run_until_complete(main, retry=False)
PYEOF
}
