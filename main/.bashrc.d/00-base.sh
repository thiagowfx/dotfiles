#!/bin/bash
#
# Base shell functions.

# Exports a shell environment variable.
#   $1 What environment variable to export.
#   $2 The value to export.
#   $3 Optional. If provided will only export the variable if the program exists.
#   $4 Optional. If provided will only export the variable if the file exists.
add_env() {
	[ -n "$3" ] && ! hash "$3" >/dev/null 2>&1 && return
	[ -n "$4" ] && [ ! -e "$4" ] && return

	export "$1"="$2"
}

# Adds a path to $PATH if it exists.
#   $1 The path to add.
#   $2 Optional. If "after", appends instead of prepending.
pathmunge() {
	if [ -e "$1" ]; then
		if ! echo "$PATH" | grep -E -q "(^|:)$1($|:)"; then
			if [ "$2" = "after" ]; then
				PATH="$PATH:$1"
			else
				PATH="$1:$PATH"
			fi
		fi
	fi
}

# Sources the given files and directories (recursively) if they exist.
#   $1 If "--shallow", does not recurse directories.
src_files() {
        [ "$1" = "--shallow" ] && local shallow=1 && shift

        for f in "$@"; do
                # Source directories recursively, so long as --shallow is not specified.
                if [ -d "$f" ]; then
                        if [ -n "$shallow" ]; then
                                # Use process substitution in order to avoid spawning a subshell.
                                # https://stackoverflow.com/questions/13726764/while-loop-subshell-dilemma-in-bash
                                while read -r -d $'\0' s; do
                                        # shellcheck source=/dev/null
                                        . "$s" || true
                                done < <(find "$f" -maxdepth 1 -type f -print0)
                        else
                                src_files "$f"/* || true
                        fi
                # Source files.
                elif [ -f "$f" ]; then
                        # shellcheck source=/dev/null
                        . "$f" || true
                fi
        done
}