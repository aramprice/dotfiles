# dotfiles

## Assumptions

- You are using `zsh`

## Installation

### Clone this repo

```
git clone git@github.com/aramprice/dotfiles "${HOME}/workspace/dotfiles"
```

### Run Setup script

```
cd ~/workspace/dotfiles && ./setup
```

This will:
1. Install Homebrew (see: https://brew.sh/)
2. Converge the `Brewfile` (see: https://github.com/Homebrew/homebrew-bundle)
3. Symlink the content of `dotfiles/` to `${HOME}` (see: https://github.com/thoughtbot/rcm)

Before creating symlinks `rcup` will do the following:
- Create a `${HOME}/.gitconfig` which sources `${HOME}/.config/git/config-include`
- Make permissions on `/usr/local/share` amenable to `zsh compinit`

### Configure macOS Settings

Optional. Set some macOS, and App settings, see [`macos_setup`](dotfiles/profile#L15-L66) for details.

```
source "${HOME}/.profile" && macos_setup
```
