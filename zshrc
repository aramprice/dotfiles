#!/usr/bin/env zsh

test -f "${HOME}/.profile" && source "${HOME}/.profile"

source "${BREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "${BREW_PREFIX}/share//zsh-history-substring-search/zsh-history-substring-search.zsh"
source "${BREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

bindkey -e # emacs bindings ctl-{a|e|k|...}

## History
export SAVEHIST=1000000
export HISTSIZE=1000000
setopt append_history
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_verify
setopt inc_append_history
setopt share_history

## Completions Setup
fpath=("${BREW_PREFIX}/share/zsh-completions" $fpath) # Homebrew zsh completions

autoload -Uz compinit && compinit
# case insensitive path-completion
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'
# partial completion suggestions
zstyle ':completion:*' list-suffixes
zstyle ':completion:*' expand prefix suffix

## Prompt
setopt prompt_subst

autoload -U colors && colors
autoload -Uz vcs_info
zstyle ":vcs_info:*" enable git
zstyle ':vcs_info:git*:*' get-revision true
zstyle ':vcs_info:git*:*' check-for-changes true
zstyle ":vcs_info:*" formats "%m %b"
zstyle ":vcs_info:*" actionformats "%m %b|%{$fg[red]%}%a%{$reset_color%}"
zstyle ':vcs_info:git*+set-message:*' hooks git-st

function +vi-git-st() {
  case "$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')" in
  "0")
    hook_com[branch]="%{${fg[green]}%}✓%{$reset_color%} %{${fg[white]}%}${hook_com[branch]}%{${reset_color}%}"
    ;;
  *)
    hook_com[branch]="%{${fg[red]}%}✗%{$reset_color%} %{${fg[white]}%}${hook_com[branch]}%{${reset_color}%}"
    ;;
  esac
}

precmd() {
  vcs_info
}

PROMPT='%{$fg[cyan]%}%D{%H:%M:%S}%{$reset_color%} %{$fg[green]%}%~%{$reset_color%}${vcs_info_msg_0_} %{$fg[green]%}%# %{$reset_color%}'
