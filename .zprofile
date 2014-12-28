#!/bin/sh

# zshrc
[[ -f ~/.zshrc.local ]] && . ~/.zshrc.local

# Keychain: ssh-agent and gpg-agent
eval $(keychain --eval -Q --quiet id_dsa id_rsa A905373C)

