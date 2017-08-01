# aliases
alias ls='ls -FG'
alias la='ls -a'
alias ll='ls -l'

# macOS Settings
macos_setup() {
  defaults write com.apple.dock persistent-apps -array
  defaults write com.apple.dock autohide -boolean true
  defaults write com.apple.dock orientation -string left
}

# Prompt Setup
git_branch() {
  git_dir=$(git rev-parse --show-toplevel 2>/dev/null)

  if [ $? -eq 0 ]; then
    pushd ${git_dir} >/dev/null
      branch=$(git branch --points-at=HEAD | grep -E '^\*' | tr -d '\n' | sed 's/^* //')
      if [ "$branch" == 'no branch' ]; then
        branch=$(git rev-list --abbrev-commit --max-count=1 HEAD)
      fi
    popd >/dev/null

    echo "${branch}"
  fi
}

git_prompt() {
  local red="\[\e[0;31m\]"
  local green="\[\e[0;32m\]"

  local reset_color="\[\e[39m\]"

  branch=$(git_branch)
  if [ -z "${branch}" ]; then
    return
  fi

  if [ `git status --porcelain | wc -l` -gt 0 ]; then
    status="${red}✗${reset_color}"
  else
    status="${green}✓${reset_color}"
  fi

  echo "${reset_color}| ${green}${branch}${reset_color} ${status}"
}

set_ps1() {
  local green="\[\e[0;32m\]"
  local purple="\[\e[0;35m\]"
  local cyan="\[\e[0;36m\]"

  local reset_color="\[\e[39m\]"

  export PS1="\n|${cyan} $(date  +'%Y-%m-%d %H:%M:%S')${reset_color} ${purple}\h${reset_color}:${green}\w
$(git_prompt) ${green}→${reset_color} "
}
PROMPT_COMMAND=set_ps1
#/Prompt Setup

# brew configuration
export HOMEBREW_NO_ANALYTICS=1
