# Julian's config for zsh
# Based on Luke Smith's config https://github.com/LukeSmithxyz/voidrice/

# Display a "motd"
shell_motd && echo ""


# ***** Setting up prompt

# Add fancy git prompt
# https://git-scm.com/book/en/v2/Appendix-A%3A-Git-in-Other-Environments-Git-in-Zsh

autoload -U colors && colors
autoload -Uz vcs_info

PROMPT="%B%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%m %{$fg[magenta]%}%4~ %{$reset_color%}>%b "

# Add fancy git prompt
# https://git-scm.com/book/en/v2/Appendix-A%3A-Git-in-Other-Environments-Git-in-Zsh
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
last_err_fancy() {
	exitcode="$?"
	if [ "$exitcode" -eq 0 ] ; then
		# printf "✔️"
	else
		printf "❌$exitcode"
	fi
}
RPROMPT="\$vcs_info_msg_0_%{$fg[red]%}\$(last_err_fancy)%{$reset_color%}"
ZLE_RPROMPT_INDENT="0"
zstyle ':vcs_info:git:*' formats "%{$fg[yellow]%} %b%{$reset_color%} "

# ***** Setting up auto complete

autoload -Uz compinit
zmodload zsh/complist
zstyle ':completion:*' menu select
# https://stackoverflow.com/a/24237590
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[.,_-]=* r:|=*' 'l:|=* r:|=*'
compinit

# Include hidden files in autocomplete:
_comp_options+=(globdots)


# ***** Sourcing other files

# Function to source a script, if it exists
_source_if_available() {
	[ -f "$1" ] && source "$1"
}

# Sourcing .env to update environment variables. A bit of a hack but hey as long as it works.
_source_if_available "$HOME/.env"

_source_if_available "$XDG_CONFIG_HOME/aliasrc"
_source_if_available "$ZDOTDIR/.zshfunctions"
_source_if_available "/usr/share/zsh-theme-powerlevel9k/powerlevel9k.zsh-theme"

# Undefining function
unfunction _source_if_available

# Enable zsh history
HISTFILE="$XDG_CACHE_HOME/zshhistory"
HISTSIZE=1500
SAVEHIST=1500

# ***** Key bindings
# Enable "delete" key
bindkey "\e[3~" delete-char
# Enable Ctrl+left/right
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
# Enable pos1 and end
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
# Ctrl+Delete and Ctrl+Backspace
bindkey "^[[3;5~" kill-word
bindkey "^H" backward-kill-word

# TODO:
# https://unix.stackexchange.com/questions/258656/how-can-i-have-two-keystrokes-to-delete-to-either-a-slash-or-a-word-in-zsh
# https://unix.stackexchange.com/questions/313806/zsh-make-altbackspace-stop-at-non-alphanumeric-characters

# **** SSH Keys
# Using keychain to manage ssh keys
# because ssh-agent is anoying
eval $(keychain -q --agents ssh --eval "$HOME/.ssh/id_rsa")
