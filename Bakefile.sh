# shellcheck shell=bash

task.run() {
	local token="$GITHUB_TOKEN"
	[ -z "$token" ] && token="$(<.env)"
	local username=hyperupcall

	time uv run starred --username "$username" --token "$token" --sort "$@" > './README.md'
	time uv run starred --username "$username" --token "$token" --sort --topics "$@" > './README-topics.md'
}
