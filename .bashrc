# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# default config
[[ -f ~/.aliases ]] && . ~/.aliases
[[ -f /etc/bashrc ]] && . /etc/bashrc
PS1='\[\033[01;32m\]\u@\h\[\033[00m\] \[\033[01;34m\]\W\[\033[00m\]\[\033[1;32m\] \$\[\033[m\] '

# autocompletion
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
    complete -cf sudo
fi

# set options
set -o emacs
shopt -s checkwinsize
shopt -s cdspell
shopt -s cmdhist
shopt -s dotglob
shopt -s expand_aliases
shopt -s extglob
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

# git support
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1) /'
}
PS1="\[\e[0;32m\]\$(parse_git_branch)\[\e[m\]$PS1"

# ccache
export PATH="/usr/lib/ccache/bin/:$PATH"
export PATH="/opt/android-sdk/platform-tools/:$PATH"
