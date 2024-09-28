#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/variables.sh"
source "$CURRENT_DIR/shared.sh"


start_pipe_pane() {
	local file=$(expand_tmux_format_path "${logging_full_filename}")
	"$CURRENT_DIR/start_logging.sh" "${file}" "${logging_filter}"
	display_message "Started logging to ${file}"
	set_active_logging_filename "${file}"
}

stop_pipe_pane() {
	tmux pipe-pane
	display_message "Ended logging to $(get_active_logging_filename)"
	unset_active_logging_filename
}

set_active_logging_filename() {
	tmux set-option -pq @active-logging-filename "$1"
}

unset_active_logging_filename() {
	tmux set-option -pu @active-logging-filename
}

get_active_logging_filename() {
	tmux show-option -pqv @active-logging-filename
}

# this function checks if logging is happening for the current pane
is_logging() {
	if [ -n "$(get_active_logging_filename)" ]; then
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
