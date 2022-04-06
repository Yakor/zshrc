#!/bin/zsh

# выключаем autocorrect
unsetopt correct
autoload -U colors && colors

# completion
autoload -U compinit && compinit
zstyle ':completion:*' menu select=0

# number of lines kept in history
export HISTSIZE=10000
# number of lines saved in the history after logout
export SAVEHIST=10000
# location of history
export HISTFILE=~/.zhistory
# append command to history file once executed
setopt inc_append_history
setopt hist_ignore_dups
setopt hist_find_no_dups

bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

# Чтобы backspace и цвета нормально работали
TERM=xterm-256color

autoload -Uz vcs_info
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '%F{red} Unstaged'   # display this when there are unstaged changes
zstyle ':vcs_info:*' stagedstr '%F{yellow} +'  # display this when there are staged changes
zstyle ':vcs_info:*' actionformats '%F{5} ( %F{2} %b%F{3} | %F{1}%a %c %u %m %F{5} ) %f '
zstyle ':vcs_info:*' formats '%F{244} [ %F{2} (%s) (%r) (%b) (%c) (%u) (%m) %F{244} ] %f '
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*+set-message:*' hooks untracked-git

+vi-untracked-git() {
  if command git status --porcelain 2>/dev/null | command grep -q '??'; then
    hook_com[misc]='%F{124}(+)%f'
  else
    hook_com[misc]='%F{240}(+)%f'
  fi
}

gentoo_precmd() {
  vcs_info
}
setopt prompt_subst

autoload -U add-zsh-hook
add-zsh-hook precmd gentoo_precmd

RPROMPT="%F{23}%T"
# user & host
PROMPT="%(!.%B%F{1}%m.%B%F{22}%n@%F{28}%m):"
PROMPT=$PROMPT"%f%b%u"
# working dir
PROMPT=$PROMPT"%F{32}%~"
PROMPT=$PROMPT"%f%b"
# git
PROMPT=$PROMPT' ${vcs_info_msg_0_}'
PROMPT=$PROMPT"%f%b"
# prompt
PROMPT=$PROMPT'
> '
PROMPT=$PROMPT"%f%b"

if [[ "$TERM" == "dumb" ]]
then
  unsetopt zle
  unsetopt prompt_cr
  unsetopt prompt_subst
  unfunction precmd
  unfunction preexec
  PS1='$ '
fi
