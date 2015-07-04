# -*- shell-script -*-

# if not running interactively, don't do anything
[[ $- != *i* ]] && return

# aliases
S="$(dirname $(readlink -f "$0"))"
[[ -f $S/.alias ]] && . $S/.alias

# bash: don't add two equal consecutive commands in bash history (add just one)
export HISTCONTROL="ignoreboth"

# autojump: debian; arch
[[ -f /usr/share/autojump/autojump.bash ]] && source /usr/share/autojump/autojump.bash
[[ -f /etc/profile.d/autojump.bash ]] && source /etc/profile.d/autojump.bash

# system bashrc and completion for sudo
[[ -f /etc/bashrc ]] && source /etc/bashrc
[[ -f /etc/bash_completion ]] && source /etc/bash_completion
complete -cf sudo

# command-not-found hook: arch
[[ -f /usr/share/doc/pkgfile/command-not-found.bash ]] && source /usr/share/doc/pkgfile/command-not-found.bash

# set prompt
git_branch() { git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1) /'; }
PS1="\[\e[0;32m\]\$(git_branch)\[\e[m\]\[\033[01;32m\]\u@\h\[\033[00m\] \[\033[01;34m\]\W\[\033[00m\]\[\033[1;32m\] \$\[\033[m\] "
[[ -f $S/.bash_prompt ]] && . $S/.bash_prompt ]]

# shell options
set -o emacs
shopt -s autocd
shopt -s checkwinsize
shopt -s cdspell
shopt -s cmdhist
shopt -s checkjobs
shopt -s dotglob
shopt -s expand_aliases
shopt -s extglob
shopt -s globstar
shopt -s histappend
shopt -s hostcomplete
shopt -s nocaseglob

# colored man pages
man() {
    env LESS_TERMCAP_mb=$'\E[01;31m' \
        LESS_TERMCAP_md=$'\E[01;38;5;74m' \
        LESS_TERMCAP_me=$'\E[0m' \
        LESS_TERMCAP_se=$'\E[0m' \
        LESS_TERMCAP_so=$'\E[38;5;246m' \
        LESS_TERMCAP_ue=$'\E[0m' \
        LESS_TERMCAP_us=$'\E[04;38;5;146m' \
        man "$@"
}
