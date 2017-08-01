# aliases
alias ls='ls -FG'
alias la='ls -a'
alias ll='ls -l'

# macOS Settings
macos_setup() {
  defaults write com.apple.dock persistent-apps -array
  defaults write com.apple.dock autohide -boolean true
  defaults write com.apple.dock orientation -string left
}

# brew configuration
export HOMEBREW_NO_ANALYTICS=1
