#!/usr/bin/env bash

## Aliases
if ls --color > /dev/null 2>&1; then # GNU `ls`
  alias ls="ls -F --color=always"
else # bsd `ls`
  alias ls="ls -F -G"
fi
alias ll="ls -l"
alias la="ls -a"
alias sbp='source ~/.bashrc'
alias vi='vim'
alias vim='nvim'

## Functions
pullify() {
  git config --add remote.origin.fetch '+refs/pull/*/head:refs/remotes/origin/pr/*'
  git fetch origin
}

git_branch() {
  local original_dir
  original_dir="$(pwd)"
  local git_dir
  git_dir=$(git rev-parse --show-toplevel 2>/dev/null)

  if [[ $? -eq 0 ]]; then
    cd "${git_dir}" || exit
      branch=$(git branch --points-at=HEAD 2>/dev/null | grep -E '^\*' | tr -d '\n' | sed 's/^* //')
      if [[ "$branch" == 'no branch' ]]; then
        branch=$(git rev-list --abbrev-commit --max-count=1 HEAD)
      fi
    cd "${original_dir}" || exit

    echo "${branch}"
  fi
}

git_prompt() {
  local red="\\[\\e[0;31m\\]"
  local green="\\[\\e[0;32m\\]"
  local reset_color="\\[\\e[39m\\]"

  branch=$(git_branch)
  if [[ -z "${branch}" ]]; then
    return
  fi

  if [[ "$(git status --porcelain | wc -l)" -gt 0 ]]; then
    status="${red}✗${reset_color}"
  else
    status="${green}✓${reset_color}"
  fi

  echo "${reset_color}${status}${green} ${branch}${reset_color} ${reset_color}"
}

set_ps1() {
  local green="\\[\\e[0;32m\\]"
  local purple="\\[\\e[0;35m\\]"
  local cyan_bold="\\[\\e[36;1m\\]"
  local reset_color="\\[\\e[39m\\]"

  PS1="
${cyan_bold}$(date +'%H:%M:%S') ${purple}\\h ${reset_color}in ${green}\\w
${cyan_bold}$(git_prompt)${green}→${reset_color} "

  export PS1
}

## Golang: This has to happen after GVM otherwise GOPATH will get unset
export GOPATH="${HOME}/go"
export PATH=${PATH}:"${GOPATH}/bin":/usr/local/go/bin

## Chruby + Ruby
chruby_script="/usr/local/share/chruby/chruby.sh"
if [[ -f "${chruby_script}" ]]; then
  source "${chruby_script}"
  chruby ruby
fi

if command -v ruby > /dev/null && command -v gem > /dev/null; then
  GEM_HOME="$(ruby -e 'puts Gem.user_dir')"
  export GEM_HOME
  export PATH=${PATH}:"${GEM_HOME}/bin"
fi

## Git Duet
export GIT_DUET_ROTATE_AUTHOR=1
export GIT_DUET_SET_GIT_USER_CONFIG=1
export GIT_DUET_GLOBAL=true

## Don't check mail when opening terminal.
unset MAILCHECK

## Default Editor
export EDITOR="nvim"

## Force xterm-256color
export TERM="xterm-256color"

## HISTORY
export HISTCONTROL=ignoreboth
HISTSIZE=64000 # set a large history size
HISTFILESIZE=$HISTSIZE
shopt -s histappend # append history file instead of overwriting

## PATH
export PATH=${HOME}/.local/bin:${HOME}/bin:${PATH} # Add  ~/.local/bin, ~/bin PATH

## PS1 - after PATH
PROMPT_COMMAND=set_ps1

## Direnv
eval "$(direnv hook bash)"

[[ -f /usr/local/etc/bash_completion ]] && . /usr/local/etc/bash_completion

[[ -f ~/.fzf.bash ]] && source "${HOME}/.fzf.bash"
