# dotfiles

## Assumptions

- You are using bash
- You have [homebrew](https://brew.sh) installed
- You have a workspace directory
  - `mkdir ~/workspace/`

## Installation

Clone this repo

```
git clone https://github.com/aramprice/dotfiles.git ~/workspace/
```

Install [rcm](https://github.com/thoughtbot/rcm)

```
brew install thoughtbot/formulae/rcm
```

Install the dotfiles

```
RCRC=~/workspace/dotfiles/rcrc rcup -v
```
