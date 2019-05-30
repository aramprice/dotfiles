# dotfiles

## Assumptions

- You are using bash

## Installation

### Clone this repo

```
mkdir -p "${HOME}/workspace" && \
  cd "${HOME}/workspace" && \
  git clone git@github.com/aramprice/dotfiles
```

#### Install `brew`

```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

via: https://brew.sh/

#### Converge the [Brewfile](https://github.com/Homebrew/homebrew-bundle)

```
cd "${HOME}/workspace/aramprice/dotfiles/" &&
  brew bundle
```

#### Link dotfiles

```
RCRC="${HOME}/workspace/aramprice/dotfiles/rcrc" rcup -v
```

The `rcup` command should have been installed by `brew bundle` above.

#### Install Luan's [nvim](https://github.com/luan/nvim) config

```
mkdir -p ~/.config && \
  git clone https://github.com/luan/nvim ~/.config/nvim
```

##### Install neovim pything bindings

```
pip3 install neovim
```

Both `nvim`, and `python` should have been install by `brew bundle` above.

#### Configure macOS Settings

```
source "${HOME}/.bash_profile" &&
  macos_setup
```
