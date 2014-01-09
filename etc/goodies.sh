# VLSub: VLC extension to download subtitles
mkdir -p ~/.local/share/vlc/lua/extensions && cd $_
wget https://raw.github.com/exebetche/vlsub/master/vlsub.lua

# Calibre Download and/or Update
# sudo python -c "import sys; py3 = sys.version_info[0] > 2; u = __import__('urllib.request' if py3 else 'urllib', fromlist=1); exec(u.urlopen('http://status.calibre-ebook.com/linux_installer').read()); main()"

# Default applications / MIME types
xdg-mime default zathura.desktop application/pdf
xdg-mime default Thunar.desktop inode/directory
xdg-mime default kde4/ktorrent.desktop x-scheme-handler/magnet