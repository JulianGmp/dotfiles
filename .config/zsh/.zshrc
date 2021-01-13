# Julian's config for zsh
# Based on Luke Smith's config https://github.com/LukeSmithxyz/voidrice/

# Display a "motd"
shell_motd && echo ""


autoload -U colors && colors

PS1="%B%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%m %{$fg[magenta]%}%2~ %{$reset_color%}$%b "

# Luke's prompt
# PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit

# Include hidden files in autocomplete:
_comp_options+=(globdots)


# Function to source a script, if it exists
_source_if_available() {
	[ -f "$1" ] && source "$1"
}

_source_if_available "$XDG_CONFIG_HOME/aliasrc"
_source_if_available "$ZDOTDIR/.zshfunctions"
_source_if_available "/usr/share/zsh-theme-powerlevel9k/powerlevel9k.zsh-theme"

# Undefining function
unfunction _source_if_available

# Enable zsh history
HISTFILE="$XDG_CACHE_HOME/zshhistory"
HISTSIZE=1500
SAVEHIST=1500

# Key bindings
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

# Add SSH ids to the agent if necessary
ssh_agent_add_id
