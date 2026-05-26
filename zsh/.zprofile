# Poetry
export PATH="$HOME/.poetry/bin:$PATH"

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init --path)"
#
# GPG setup
export GPG_TTY=$(tty)

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Cargo / rustup — login shells only (scripts via `zsh -c` don't need cargo
# on PATH). Guard for fresh-clone safety: file may not exist before rustup
# runs on a new machine.
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
