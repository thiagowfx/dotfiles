#!/bin/sh
# startx / xinit <window_manager>

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

[[ -f "$HOME/.xprofile" ]] && sh "$HOME/.xprofile"

WM=${1:-i3}

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
  i3|i3wm|*         ) exec i3;;
esac
