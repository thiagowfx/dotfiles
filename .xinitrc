#!/bin/sh
#
# Example usage: 
#   WM=i3 startx
#   WM=cinnamon startx
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
#
# Arguments:
#   $1: what should be executed
#   $2: program that should exist (e.g. vim)
#   $3: an optional file (full-path) (e.g. $HOME/.vimrc)
#
startprog() {
  [[ "x$3" != "x" ]] && [ ! -e "$3" ] && return
  command -v "$2" &>/dev/null && "$1" &
}

# compton (desktop composition)
startprog "compton -b" compton

# pulseaudio
startprog "start-pulseaudio-x11" pulseaudio

# redshift
startprog "redshift -l -23:-43" redshift

# network manager applet
startprog "nm-applet" nm-applet

# syndaemon: no touchpad clicking while typing
startprog "syndaemon -i 1 -t -k -d" syndaemon

# unclutter: hide the mouse when it is idle for a while
startprog "unclutter" unclutter

# feh: set desktop background
startprog "sh $HOME/.fehbg" feh "$HOME/.fehbg"

# Xresources
startprog "xrdb -merge $HOME/.Xresources" xrdb "$HOME/.Xresources"

# Xmodmap
startprog "xmodmap $HOME/.xmodmap" xmodmap "$HOME/.xmodmap"

case $WM in
  awesome           ) exec awesome;;
  bspwm             ) exec bspwm;;
  catwm             ) exec catwm;;
  cinnamon          ) exec cinnamon-session;;
  dwm               ) exec dwm;;
  e17               ) exec enlightenment_start;;
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
  *                 ) command -v i3 &>/dev/null && exec i3 || { 
    echo "Error: i3 not found on your system"
    return 1
  };;
esac
