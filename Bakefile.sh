# shellcheck shell=bash

task.run() {
	local token="$GITHUB_TOKEN"
	[ -z "$token" ] && token="$(<.env)"
	local username=hyperupcall

	uv run starred --username "$username" --token "$token" --sort "$@" > './by-language.md'
	uv run starred --username "$username" --token "$token" --sort --topic "$@" > './by-topics.md'
	task.process-files
}

task.process-files() {
	sed -i "s/^# Awesome Stars.*/# Edwin's GitHub Stars/" ./by-*.md
	sed -i "s/curated list/list/" ./by-*.md
	mkdir -p ./website/content/pages
	cp ./by-*.md ./website/content/pages
}
