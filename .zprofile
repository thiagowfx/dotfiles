#!/bin/sh

# zshrc
[[ -f ~/.zshrc.local ]] && . ~/.zshrc.local

export GPG_TTY=$(tty)
export GPG_AGENT_INFO=""

# Keychain: ssh-agent autostart
eval $(keychain --eval -Q --quiet id_dsa id_rsa)

# autostart X on tty1
[[ -z "${DISPLAY}" && "${XDG_VTNR}" -eq 1 ]] && exec startx
