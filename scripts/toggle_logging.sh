#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/variables.sh"
source "$CURRENT_DIR/shared.sh"


start_pipe_pane() {
	local file=$(expand_tmux_format_path "${logging_full_filename}")
	"$CURRENT_DIR/start_logging.sh" "${file}"
	display_message "Started logging to ${file}"
	set_logging_variable "${file}"
}

stop_pipe_pane() {
	tmux pipe-pane
	display_message "Ended logging to $(get_logging_variable)"
	unset_logging_variable
}

# saving 'logging' 'not logging' status in a variable unique to pane
set_logging_variable() {
	tmux set-option -pq @logging-variable "$1"
}

unset_logging_variable() {
	tmux set-option -pu @logging-variable
}

get_logging_variable() {
	tmux show-option -pqv @logging-variable
}

# this function checks if logging is happening for the current pane
is_logging() {
	if [ -n "$(get_logging_variable)" ]; then
		return 0
	else
		return 1
	fi
}

# starts/stop logging
toggle_pipe_pane() {
	if is_logging; then
		stop_pipe_pane
	else
		start_pipe_pane
	fi
}

main() {
	if supported_tmux_version_ok; then
		toggle_pipe_pane
	fi
}
main
