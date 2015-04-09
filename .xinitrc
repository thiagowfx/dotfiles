#!/bin/sh
#
# Example usage: 
#   WM=i3 startx
# Use either xinit or startx.
#

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

#
# start a program automatically if 
# 1) it is installed on the system
# 2) an (optional) file provided as argument exists on the system
# 3) it is not runing already
#
# Arguments:
#   $1: what should be executed
#   $2: program that should exist (e.g. vim)
#   $3: an optional file (full-path) (e.g. $HOME/.vimrc)
#
startprog() {
  [[ "x$2" != "x" ]] && ! command -v "$2" &>/dev/null && return
  command -v pidof &>/dev/null && pidof "$2" &>/dev/null && return
  [[ "x$3" != "x" ]] && [ ! -e "$3" ] && return
  eval "$1" &
}

# compton (desktop composition)
startprog "compton -b" compton

# pulseaudio
startprog "start-pulseaudio-x11" pulseaudio

# redshift (color temperature adjustment)
startprog "redshift -l -23:-43" redshift

# network manager applet
startprog "nm-applet" nm-applet

# syndaemon: no touchpad clicking while typing
startprog "syndaemon -i 1 -t -k -d" syndaemon

# unclutter: hide the mouse when it gets idle for a while
startprog "unclutter" unclutter

# feh: set desktop background
startprog "sh $HOME/.fehbg" feh "$HOME/.fehbg"

# Xresources
startprog "xrdb -merge $HOME/.Xresources" xrdb "$HOME/.Xresources"

# Xmodmap
startprog "xmodmap $HOME/.xmodmap" xmodmap "$HOME/.xmodmap"

# X cursor: needed for some window managers (e.g. xmonad)
startprog "xsetroot -cursor_name left_ptr" xsetroot

# X keymap: can be permanently set with `localectl set-x11-keymap` (part of systemd)
startprog "setxkbmap br; setxkbmap -option terminate:ctrl_alt_bksp" setxkbmap

# X11 clipboard syncing
# startprog "autocutsel -fork; autocutsel -selection PRIMARY -fork" autocutsel
startprog "parcellite --daemon" parcellite

# icons on the desktop for tiling window managers
startprog "idesk" idesk "$HOME/.idesktop"

# WM: The window manager to be started.
WM=${WM:-i3}

case $WM in
  awesome           ) exec awesome;;
  bspwm             ) exec bspwm;;
  catwm             ) exec catwm;;
  cinnamon          ) exec cinnamon-session;;
  dwm               ) exec dwm;;
  e17|enlightenment ) exec enlightenment_start;;
  ede               ) exec startede;;
  fluxbox           ) exec startfluxbox;;
  gnome             ) exec gnome-session;;
  hawaii            ) exec hawaii;;
  i3|i3wm           ) exec i3;;
  icewm             ) exec icewm-session;;
  jwm               ) exec jwm;;
  kde               ) exec startkde;;
  lxde              ) exec startlxde;;
  mate              ) exec mate-session;;
  monster           ) exec monsterwm;;
  notion            ) exec notion;;
  openbox           ) exec openbox-session;;
  unity             ) exec unity;;
  xfce|xfce4        ) exec startxfce4;;
  xmonad            ) exec xmonad;;
  windowmaker       ) exec wmaker;;
  *                 ) exec "$WM";;
esac
