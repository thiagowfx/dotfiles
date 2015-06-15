#!/bin/sh

command -v lxterminal &>/dev/null && export TERMINAL="lxterminal"

# GnuPG: password only once per session
export GPG_TTY=$(tty)
export GPG_AGENT_INFO=""

# Keychain: ssh-agent autostart
# eval $(keychain --agents ssh --eval -Q --quiet id_dsa id_rsa)

# autostart X on tty1
[[ -z "${DISPLAY}" && "${XDG_VTNR}" -eq 1 ]] && exec startx
