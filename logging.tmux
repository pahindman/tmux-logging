#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/scripts/variables.sh"
source "$CURRENT_DIR/scripts/shared.sh"


main() {
	tmux bind-key "$logging_key" run-shell "$CURRENT_DIR/scripts/toggle_logging.sh"
	tmux bind-key "$pane_screen_capture_key" run-shell "$CURRENT_DIR/scripts/screen_capture.sh"
	tmux bind-key "$save_complete_history_key" run-shell "$CURRENT_DIR/scripts/save_complete_history.sh"
	tmux bind-key "$clear_history_key" run-shell "$CURRENT_DIR/scripts/clear_history.sh"

	if [ "$automatic_logging" = "on" ]; then
		local num_hooks=$(tmux show-hooks -g after-new-window | wc -l)
		tmux set-hook -g after-new-window[$num_hooks] "run-shell \"$CURRENT_DIR/scripts/toggle_logging.sh\""
		num_hooks=$(tmux show-hooks -g after-split-window | wc -l)
		tmux set-hook -g after-split-window[$num_hooks] "run-shell \"$CURRENT_DIR/scripts/toggle_logging.sh\""
	fi
}

main
