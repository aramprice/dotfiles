#!/usr/bin/env bash

# shellcheck source=profile
test -f "${HOME}/.profile" && source "${HOME}/.profile"

test -f "${BREW_PREFIX}/etc/bash_completion" && source "${BREW_PREFIX}/etc/bash_completion"

## Direnv
if command -v direnv > /dev/null; then
  eval "$(direnv hook bash)"
fi

## HISTORY
HISTCONTROL="ignorespace:ignoredups"
HISTSIZE=1000000
HISTFILESIZE=1000000
HISTIGNORE="ls:bg:fg:history"
shopt -s histappend # append history file instead of overwriting
shopt -s cmdhist

git_branch() {
  original_dir="$(pwd)"
  git_dir="$(git rev-parse --show-toplevel 2>/dev/null)"

  if test $? -eq 0; then
    cd "${git_dir}" || exit
      branch="$(git branch --points-at=HEAD 2>/dev/null | grep -E '^\*' | tr -d '\n' | sed 's/^* //')"
      if test "${branch}" = 'no branch'; then
        branch="$(git rev-list --abbrev-commit --max-count=1 HEAD)"
      fi
    cd "${original_dir}" || exit

    echo "${branch}"
  fi
}

prompt_command() {
  history -a; history -c; history -r; # append, clear, reload

  red='\[\e[0;31m\]'
  green='\[\e[0;32m\]'
  magenta='\[\e[0;35m\]'
  cyan='\[\e[0;36m\]'
  reset_color='\[\e[39m\]'
  time="${cyan}\t${reset_color}"
  host="${magenta}\\h${reset_color}"
  directory="${green}\\w${reset_color}"
  privilege_indicator="${green}\\$ ${reset_color}"
  git_info=""

  branch="$(git_branch)"
  if test -n "${branch}"; then
    case "$(git status --porcelain 2> /dev/null | wc -l | tr -d ' ')" in
      "0")
        state_indicator="${green}✓${reset_color}"
      ;;
      *)
        state_indicator="${red}✗${reset_color}"
      ;;
    esac

    git_info="${state_indicator} ${green}${branch}${reset_color}"
  fi

  PS1="${time} ${host}:${directory}
${git_info} ${privilege_indicator}"
}

PROMPT_COMMAND=prompt_command
