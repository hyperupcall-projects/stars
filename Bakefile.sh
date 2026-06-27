# shellcheck shell=bash

task.run() {
	local token="$GITHUB_TOKEN"
	[ -z "$token" ] && token="$(<.env)"
	local username=hyperupcall

	uv run starred --username "$username" --token "$token" --sort "$@" > './by-language.md'
	uv run starred --username "$username" --token "$token" --sort --topic "$@" > './by-topics.md'
	task.copy-files
}

task.copy-files() {
	cp ./by-*.md ./docs/content
	cp README-docs.md ./docs/content/_index.md
}
