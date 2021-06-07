#!/bin/sh

# TODO make symlinks
# TODO handle on-my-zsh config properly
#

# Install Homebrew
echo "Installing Homebrew"
if test ! $(which brew); then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/dan/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
brew update
echo "Install Homebrew Packages"
brew tap homebrew/bundle
brew bundle

# Apple dev tools
echo "Install XCode CLI Tool"
xcode-select --install

# Dock stuff
# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true
# Remove the auto-hiding Dock delay
defaults write com.apple.dock autohide-delay -float 0
# Remove the animation when hiding/showing the Dock
defaults write com.apple.dock autohide-time-modifier -float 0
# Put the dock on the right
defaults write com.apple.dock orientation -string right

# Show the ~/Library folder.
chflags nohidden ~/Library
# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Fast keyboard repeating
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 15
