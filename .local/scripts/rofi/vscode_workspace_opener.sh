#!/bin/sh

cd "$HOME" || exit


# list of .code-workspace files
files=$(
	find 'scripts/' 'source/' 'Documents/' -maxdepth 3 -type f \
		-name '*.code-workspace' \
		-not -path '*/\.*' \
		-not -ipath '*/bin/*' \
		-not -ipath '*/obj/*' \
		-not -ipath '*/Cache/*' \
		-not -ipath '*/node_modules/*' \
)

# list directories with a .vscode subdirectory
vs_directories=$(
	find 'scripts/' 'source/' 'Documents/' -maxdepth 4 -type d \
		-name '*\.vscode' \
		-not -path '*/\.git*' \
		-not -ipath '*/bin/*' \
		-not -ipath '*/obj/*' \
		-not -ipath '*/Cache/*' \
		-not -ipath '*/node_modules/*' \
)

# List .git directories
git_directories=$(
	find 'scripts/' 'source/' 'Documents/' -maxdepth 3 -type d \
		-name '.git' \
		-not -ipath '*/bin/*' \
		-not -ipath '*/obj/*' \
		-not -ipath '*/Cache/*' \
		-not -ipath '*/node_modules/*' \
)


# Delimeter between filename and path
delim='>'

get_lines() {
	# List all .code-workspace files
	for f in $files; do
		printf '%s 📄 %s%s\n' "$(basename -s '.code-workspace' "$f")" "$delim" "$f"
	done
	# List all directories with a .vscode directory, but no workspace file in them
	for d in $vs_directories; do
		d_parent=$(dirname "$d")
		[ "$(find "$HOME/$d_parent/" -maxdepth 1 -type f -name '*.code-workspace' | wc -l)" -eq 0 ] \
			&& printf '%s 📁 %s%s\n' "$(basename "$HOME/$d_parent")" "$delim" "$d_parent"
	done
	# List directories with a .git directory, but no workspace file or .vscode directory in them
	for d in $git_directories; do
		d_parent=$(dirname "$d")
		[ "$(find "$HOME/$d_parent/" -maxdepth 1 -type f -name '*.code-workspace' | wc -l)" -eq 0 ] \
		&& [ "$(find "$HOME/$d_parent/" -maxdepth 1 -type d -name '.vscode' | wc -l)" -eq 0 ] \
			&& printf '%s  %s%s\n' "$(basename "$HOME/$d_parent")" "$delim" "$d_parent"
	done
}

choice=$(get_lines | column -t | rofi -dmenu -i -p 'Code Workspace')
# If nothing was chosen
[ -z "$choice" ] && exit

path="$HOME/$(echo "$choice" | cut -d "$delim" -f2)"
code "$(readlink -f "$path")"
