# dotfiles

## Assumptions

- You are using `zsh`

## Installation

### Clone this repo

```
git clone git@github.com/aramprice/dotfiles "${HOME}/workspace/dotfiles"
```

#### Install `brew`

```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

via: https://brew.sh/

#### Converge the [Brewfile](https://github.com/Homebrew/homebrew-bundle)

```
HOMEBREW_BUNDLE_FILE="${HOME}/workspace/dotfiles/Brewfile" brew bundle
```

#### Install dotfiles and neovim

```
RCRC="${HOME}/workspace/dotfiles/rcrc" rcup -v
```

via: https://github.com/thoughtbot/rcm

This command will invoke the [`pre-up`](dotfiles/hooks/pre-up) hook which does the following:

- Clone Luan's [nvim](https://github.com/luan/nvim) config into `~/.config/nvim`
  - Install neovim python bindings (`pip3 install neovim`)

#### Configure macOS Settings

Optional. Set some macOS, and App settings, see [`macos_setup`](dotfiles/profile#L15-L66) for details.

```
source "${HOME}/.profile" && macos_setup
```
