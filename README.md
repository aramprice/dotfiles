# dotfiles

## Assumptions

- You are using bash

## Installation

### Install [homebrew](https://brew.sh)

```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

### Clone this repo

```
git clone https://github.com/aramprice/dotfiles.git "${HOME}/workspace/dotfiles"
```

### Install [rcm](https://github.com/thoughtbot/rcm)

```
brew install thoughtbot/formulae/rcm
```

### Install the dotfiles

```
RCRC="${HOME}/workspace/dotfiles/rcrc" rcup -v
```

## Optional

### Install the specified formulae and casks

```
brew bundle --global
```

#### Install [luan/nvim](https://github.com/luan/nvim), and python bindings

```
git clone https://github.com/luan/nvim ~/.config/nvim && \
  pip3 install neovim
```
