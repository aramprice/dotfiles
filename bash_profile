macos_setup() {
  defaults write com.apple.dock persistent-apps -array
  defaults write com.apple.dock autohide -boolean true
  defaults write com.apple.dock orientation -string left

  defaults write com.apple.menuextra.clock DateFormat -string 'EEE MMM d H:mm'

  defaults write NSGlobalDomain AppleKeyboardUIMode -int 3 # enable full keyboard access
  # appers not to work in high sierra / 10.13
  defaults write NSGlobalDomain com.apple.keyboard.fnState -boolean true  # enable function keys
}

b_up() {
  brew upgrade --cleanup && \
  brew doctor
}

bc_up() {
  brew cask outdated && \
  brew cask cleanup && \
  brew cask doctor
}

bup() {
  b_up
  bc_up
}

source ${HOME}/.bashrc