#!/bin/sh
# Based on a similar script made by Luke Smith, licenced under GPL-3.0 at
# https://github.com/LukeSmithxyz/voidrice/blob/master/.local/bin/dmenuunicode

notify-send "Warning: the unicode_picker.sh script is broken and should be replaced but I'm too lazy. \
	I should probably rewrite this in a language that makes it easy to work with unicode."

choice=$(rofi -dmenu -i -p 'Unicode Picker' < "$HOME/.local/share/rice/unicode.txt")

# If nothing was chosen
[ -z "$choice" ] && exit

hex=$(echo "$choice" | grep -oP 'U\+\K([\0-9,a-f,A-F]+)$')
padded_hex=$(printf '%s' "00000000${hex}" | tail -c 8)
char=$(env printf "\U${padded_hex}")

# Copy selected character to clipboard
printf '%s' "$char" | xclip -selection clipboard
notify-send "'$char' (U+${hex}) copied to clipboard."

