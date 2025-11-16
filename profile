#!/usr/bin/env sh

if [ -x "$(command -v brew)" ]; then
  BREW_PREFIX="$(brew --prefix)"
else
  if [ "$(uname -p)" = 'arm' ]; then
    BREW_PREFIX='/opt/homebrew'
  else
    BREW_PREFIX='/usr/local'
  fi
fi
export BREW_PREFIX

if command -v eza >/dev/null; then
  alias ls="eza"
  alias tree="eza --tree"
fi
alias ls="ls -F --color=auto"
alias ll="ls -l"
alias la="ls -a"

alias vi='vim'
alias vim='nvim'

macos_setup() {
  defaults write NSGlobalDomain AppleICUDateFormatStrings -dict "1" "y-MM-dd" # sane date format
  defaults write NSGlobalDomain AppleICUForce24HourTime -int 1
  defaults write NSGlobalDomain AppleFirstWeekday -dict "gregorian" "2"  # first day of the week is monday
  defaults write NSGlobalDomain com.apple.keyboard.fnState -boolean true # enable function keys
  defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false     # Key repeats when you hold it

  defaults write com.apple.dock persistent-apps -array
  defaults write com.apple.dock autohide -boolean true
  defaults write com.apple.dock orientation -string left
  defaults write com.apple.dock persistent-apps -array # <- clears apps "saved" to dock
  defaults write com.apple.dock show-recents -bool false

  # Enable snap-to-grid for icons across Desktop, Standard View, and
  for view_setting in "DesktopViewSettings" "FK_StandardViewSettings" "StandardViewSettings"; do
    /usr/libexec/PlistBuddy -c "Set :${view_setting}:IconViewSettings:arrangeBy grid" \
      "${HOME}/Library/Preferences/com.apple.finder.plist"
  done

  defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv" # default to list view (others: `icnv`, `clmv`, `glyv`)
  defaults write com.apple.finder NewWindowTarget -string "PfHm"      # Finder opens $HOME

  # Expand “General”, “Open with”, and “Sharing & Permissions” File Info panes:
  defaults write com.apple.finder FXInfoPanesExpanded -dict \
    General -bool true \
    OpenWith -bool true \
    Privileges -bool true

  # Disable Click to Show Desktop
  defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false

  for app in "Dock" "Finder"; do
    echo "Restarting ${app}"
    killall -HUP "${app}"
  done
}

# Homebrew
export HOMEBREW_NO_ANALYTICS=1         # Turn of homebrew data collection
export HOMEBREW_BUNDLE_NO_LOCK=1       # No brew lockfile
export HOMEBREW_NO_INSECURE_REDIRECT=1 # Disallow `https` => `http` redirects
export HOMEBREW_CASK_OPTS='--require-sha'
export HOMEBREW_BUNDLE_FILE="${HOME}/.Brewfile"
# shellcheck source=/dev/null
test -f "${HOME}/.homebrew-git-api-token" &&
  . "${HOME}/.homebrew-git-api-token"

bup() {
  brew update
  brew bundle cleanup --force --verbose
  brew bundle
  brew upgrade --greedy
  brew cleanup
  brew doctor
  date '+==> %Y-%m-%d %H:%M:%S'
}

## Ruby
test -f "${BREW_PREFIX}/share/chruby/chruby.sh" &&
  . "${BREW_PREFIX}/share/chruby/chruby.sh" &&
  chruby ruby
rb_inst() {
  RUBY_CONFIGURE_OPTS="--disable-install-doc --without-tcl --without-tk"
  export RUBY_CONFIGURE_OPTS
  cpus_to_use="$(printf %.0f $(($(sysctl -n hw.ncpu) * .8)))" # use 80%

  ruby-install --jobs "${cpus_to_use}" "${@}"
}

## direnv
if command -v direnv >/dev/null; then
  shell_name="$(ps -ocomm= $$ | cut -d"-" -f2)"
  test "${shell_name}" != 'sh' && eval "$(direnv hook "${shell_name}")"
fi

## Git Duet
export GIT_DUET_ROTATE_AUTHOR=1
export GIT_DUET_SET_GIT_USER_CONFIG=1
export GIT_DUET_GLOBAL=true

## Default Editor
export EDITOR="nvim"

## Force xterm-256color
export TERM="xterm-256color"

## PATH
export PATH="${BREW_PREFIX}/bin":"${BREW_PREFIX}/sbin":"${PATH}"
export PATH="${PATH}":"${GOPATH}/bin":"${BREW_PREFIX}/go/bin"
export PATH="${HOME}/.local/bin":"${HOME}/bin":"${PATH}"
