#!/usr/bin/env bash

macos_setup() {
  # inspired by https://mths.be/macos
  defaults write com.apple.dock persistent-apps -array
  defaults write com.apple.dock autohide -boolean true
  defaults write com.apple.dock orientation -string left

  defaults write com.apple.menuextra.clock DateFormat -string 'EEE MMM d H:mm'

  defaults write NSGlobalDomain AppleKeyboardUIMode -int 3 # enable full keyboard access
  # appers not to work in high sierra / 10.13
  defaults write NSGlobalDomain com.apple.keyboard.fnState -boolean true  # enable function keys
}

# Homebrew
export HOMEBREW_NO_ANALYTICS=1 # Turn of homebrew data collection
export HOMEBREW_NO_INSECURE_REDIRECT=1 # Disallow `https` => `http` redirects
export HOMEBREW_CASK_OPTS='--require-sha'

bup() {
  brew update && \
    brew bundle cleanup --global --force && \
    brew bundle --global && \
    brew upgrade && brew cask upgrade && \
    brew cleanup && \
    brew doctor ; brew cask doctor
}

source "${HOME}/.bashrc"
