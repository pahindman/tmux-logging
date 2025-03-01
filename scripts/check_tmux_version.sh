#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/variables.sh"
source "$CURRENT_DIR/shared.sh"

# this is used to get "clean" integer version number. Examples:
# `tmux 1.9` => `19`
# `1.9a`     => `19`
get_digits_from_string() {
	echo "$1" | tr -dC '[:digit:]'
}

main() {
	local supported_version_int="$(get_digits_from_string "$SUPPORTED_VERSION")"
	local current_version_int="$(get_digits_from_string "$(tmux -V)")"
	if [ "$current_version_int" -lt "$supported_version_int" ]; then
		display_message "Error, Tmux version unsupported! Please install Tmux version $SUPPORTED_VERSION or greater!"
		exit 1
	fi
}
main
