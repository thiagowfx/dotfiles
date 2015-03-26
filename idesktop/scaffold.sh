#!/bin/sh

usage() {
    cat <<HERE
"\$1" -- executable
"\$2" -- caption
"\$3" -- tooltip
"\$4" -- path to icon
HERE
}

if [ "$1" == "" ] || [ "$1" == "-h" ] || [ "$1" == "--help" ]
then
    usage
    exit 0
fi

cat >"$1.lnk" <<HERE
table Icon
  Caption: ${2:-$1}
  ToolTip.Caption: ${3:-$1}
  Icon: $4
  Width: 32
  Height: 32
  X: 500
  Y: 500
  Command[0]: $1
end
HERE
echo "--> created $1.lnk"
