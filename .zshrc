# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt beep
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/thiago/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Custom config
alias upq="sudo pacman -Syy && sudo pacman -Syu"
