# shellcheck shell=bash

task.run() {
	local token="$GITHUB_TOKEN"
	[ -z "$token" ] && token="$(<.env)"
	local username=hyperupcall

	uv run starred --username "$username" --token "$token" --sort "$@" > './README.md'
	uv run starred --username "$username" --token "$token" --sort --topic "$@" > './README-topics.md'
}
