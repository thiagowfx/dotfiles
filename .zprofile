#!/bin/sh

# zshrc
[[ -f ~/.zshrc.local ]] && . ~/.zshrc.local

# Keychain: ssh-agent and gpg-agent
eval $(keychain --eval -Q --quiet id_dsa id_rsa A905373C)

# autostart X on tty1
[[ -z "${DISPLAY}" && "${XDG_VTNR}" -eq 1 ]] && exec startx
