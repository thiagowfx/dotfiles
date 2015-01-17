#!/bin/sh
# Example usage: 
#   WM=i3 startx
#   WM=cinnamon startx
# You can use xinit too.
#

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

[[ -f "$HOME/.fehbg" ]] && which feh &>/dev/null && sh "$HOME/.fehbg" &
[[ -f "$HOME/.xprofile" ]] && sh "$HOME/.xprofile"
[[ -f "$HOME/.Xresources" ]] && which xrdb &>/dev/null & xrdb -merge "$HOME/.Xresources"
[[ -f "$HOME/.Xmodmap" ]] && which xmodmap &>/dev/null & xmodmap "$HOME/.xmodmap"

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
  xfce              ) exec startxfce4;;
  xmonad            ) exec xmonad;;
  *                 ) which i3 &>/dev/null && exec i3 || { 
    echo "Error: i3 not found on your system"
    return 1
  };;
esac
