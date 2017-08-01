# dotfiles

## Assumptions

- Your login shell is `bash`

## Installation

Download this repo

```
mkdir ~/workspace/
git clone git@github.com:aramprice/dotfiles.git ~/workspace/
```

Install [rcm](https://github.com/thoughtbot/rcm)

```
brew install thoughtbot/formulae/rcm
```

Use `rcm` to install the dotfiles

```
env RCRC=~/workspace/dotfiles/rcrc rcup -v
```
