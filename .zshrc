# variables
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
COMPLETION_WAITING_DOTS="true"
RPROMPT=""
export SHELL=/usr/bin/zsh
export PATH="/opt:$PATH"
export EDITOR="emacs -nw"
export VISUAL="emacs"
export BROWSER=/usr/bin/xdg-open

# misc
autoload -U zutil
autoload -U compinit
compinit
autoload -U complist
setopt appendhistory autocd beep extendedglob nomatch 
prompt suse

# keybindings
bindkey -e			        # emacs
bindkey '\e[A' history-search-backward
bindkey '\e[B' history-search-forward
bindkey '^K' kill-whole-line
bindkey "\e[H" beginning-of-line        # Home (xorg)
bindkey "\e[1~" beginning-of-line       # Home (console)
bindkey "\e[4~" end-of-line             # End (console)
bindkey "\e[F" end-of-line              # End (xorg)
bindkey "\e[2~" overwrite-mode          # Ins
bindkey "\e[3~" delete-char             # Delete
bindkey '\eOH' beginning-of-line
bindkey '\eOF' end-of-line

# distro specific commands
if [[ -f /etc/arch-release ]]; then
    alias world="sudo pacman -Syy && sudo pacman -Syu"
elif
    [[-f /etc/gentoo-release]]; then
    alias world=""
fi

# aliases, tweaking some common tasks
alias cp="cp -v -i"                         # confirm before overwriting something
alias chmod="chmod -v"
alias chown="chown -v"
alias df='df -h'                          # human-readable sizes
alias cp="cp -i"  
alias free='free -m'                      # show sizes in MB
alias grep="grep --color=auto -E -d skip"
alias l="ls -1A --color=auto"
alias la='ls -la --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'
alias ls='ls --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'
alias ll='ls -l --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'
alias ln="ln -v"
alias mv="mv -v"
alias pgrep="pgrep --color=auto"
alias rm="rm -v"
alias vi="vim"

# shorthands

# mount cd/dvd
alias mount-iso="mount -o loop"

# require youtube-dl package
alias youtube-dl-mp3-download="youtube-dl -t --extract-audio --audio-format mp3"
alias youtube-dl-video-download="youtube-dl -t"

# most used commands
alias top10="fc -l 0 | awk '{print \$2}' | awk 'BEGIN {FS=\"|\"} {print \$1}' | sort | uniq -c | sort -rn | head -n 10"

# windows
alias cls="clear"
alias tracert="traceroute"
alias ipconfig="ifconfig"	# alt: ip addr

# functions
# ex - archive extractor
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}
function changeroot {
    sudo cp -L /etc/resolv.conf $1/etc/resolv.conf
    sudo mount -t proc proc $1/proc
    sudo mount -t sysfs sys $1/sys
    sudo mount -o bind /dev $1/dev
    sudo mount -t devpts pts $1/dev/pts/
    sudo chroot $1/ /bin/bash
}

# output
alsi    # alt: archey, screenfetch
