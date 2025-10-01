#!/usr/bin/env zsh

test -f "${HOME}/.profile" && emulate sh -c '. "${HOME}/.profile"'

## Direnv
if command -v direnv > /dev/null; then
  eval "$(direnv hook zsh)"
fi

# Homebrew zsh completions
fpath=("${BREW_PREFIX}/share/zsh-completions" $fpath)

bindkey -e # emacs bindings ctl-{a|e|k|...}

## History
export SAVEHIST=1000000
export HISTSIZE=1000000
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt hist_verify
setopt inc_append_history
setopt share_history

## Prompt
setopt prompt_subst

autoload -Uz compinit && compinit
autoload -U colors && colors
autoload -Uz vcs_info
zstyle ":vcs_info:*" enable git
zstyle ':vcs_info:git*:*' get-revision true
zstyle ':vcs_info:git*:*' check-for-changes true
zstyle ":vcs_info:*" formats "%m %b"
zstyle ":vcs_info:*" actionformats "%m %b|%{$fg[red]%}%a%{$reset_color%}"
zstyle ':vcs_info:git*+set-message:*' hooks git-st

source "${BREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

function +vi-git-st() {
  case "$(git status --porcelain 2> /dev/null | wc -l | tr -d ' ')" in
    "0")
	    hook_com[branch]="%{$fg[green]%}✓%{$reset_color%} ${hook_com[branch]}"
    ;;
    *)
	    hook_com[branch]="%{$fg[red]%}✗%{$reset_color%} ${hook_com[branch]}"
    ;;
  esac
}

precmd() {
  vcs_info
}

PROMPT='%{$fg[cyan]%}%*%{$reset_color%} %{$fg[green]%}%~%{$reset_color%}${vcs_info_msg_0_} %{$fg[green]%}%#%{$reset_color%} '
