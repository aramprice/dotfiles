#!/usr/bin/env bash

ls_opts='-F'
if ls --color > /dev/null 2>&1; then # GNU `ls`
  ls_opts="${ls_opts} --color=always"
else # macOS `ls`
  ls_opts="${ls_opts} -G"
fi

## Aliases
alias ls="ls ${ls_opts}"
alias ll="ls -l ${ls_opts}"
alias la="ls -a ${ls_opts}"
alias sbp='source ~/.bashrc'
alias vi='vim'
alias vim='nvim'

export EDITOR='nvim'

## Functions
pullify() {
  git config --add remote.origin.fetch '+refs/pull/*/head:refs/remotes/origin/pr/*'
  git fetch origin
}

git_branch() {
  git_dir=$(git rev-parse --show-toplevel 2>/dev/null)

  if [ $? -eq 0 ]; then
    pushd "${git_dir}" >/dev/null
      branch=$(git branch --points-at=HEAD 2>/dev/null | grep -E '^\*' | tr -d '\n' | sed 's/^* //')
      if [ "$branch" == 'no branch' ]; then
        branch=$(git rev-list --abbrev-commit --max-count=1 HEAD)
      fi
    popd >/dev/null

    echo "${branch}"
  fi
}

git_prompt() {
  local red="\\[\\e[0;31m\\]"
  local green="\\[\\e[0;32m\\]"

  local reset_color="\\[\\e[39m\\]"

  branch=$(git_branch)
  if [ -z "${branch}" ]; then
    return
  fi

  if [ "$(git status --porcelain | wc -l)" -gt 0 ]; then
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

## PS1
PROMPT_COMMAND=set_ps1

## PATH
function reorder_bin_paths() {
  local new_path=()
  local paths

  # Split path on colon
  IFS=":" paths=(${PATH})

  for path in "${paths[@]}"; do
    # Do not include /usr/local/sbin or /usr/local/bin in their normal locations
    if [ "/usr/local/sbin" == "${path}" ]; then
      continue
    fi
    if [ "/usr/local/bin" == "${path}" ]; then
      continue
    fi

    # Move theme to directly before their /usr/bin and /usr/sbin equivalents
    if [ "/usr/bin" == "${path}" ]; then
      new_path=("${new_path[@]}" "/usr/local/bin")
    fi
    if [ "/usr/sbin" == "${path}" ]; then
      new_path=("${new_path[@]}" "/usr/local/sbin")
    fi

    # Every other item should be in its natural order
    new_path=("${new_path[@]}" ${path})
  done

  # Join array on colon
  IFS=":" echo "${new_path[*]}"
}

export PATH
PATH=$(reorder_bin_paths)
unset reorder_bin_paths

## HISTORY
HISTSIZE=32000
HISTFILESIZE=$HISTSIZE
export HISTCONTROL=ignoreboth:erasedups
shopt -s histappend # append to hist file

## Force xterm-256color
export TERM="xterm-256color"

## Golang: This has to happen after GVM otherwise GOPATH will get unset
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH:/usr/local/go/bin

# Ruby
if command -v ruby > /dev/null && command -v gem > /dev/null; then
  GEM_HOME="$(ruby -e 'puts Gem.user_dir')"
  export GEM_HOME
  export PATH=${PATH}:"${GEM_HOME}/bin"
fi
## Direnv
eval "$(direnv hook bash)"
