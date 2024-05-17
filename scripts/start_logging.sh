#!/usr/bin/env bash

# path to log file - global variable
FILE="$1"
FILTER="$2"

main() {
	tmux pipe-pane "exec $FILTER >> $FILE"
}
main
