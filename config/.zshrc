
#
# .zshrc
#
# 2010-2011 Matthew Fernandez
#
# 2004-2007 David Greenaway
#
# based on 2002 Bernard Blackham
# based on ?
#

#
# Determine operating system
#
OSTYPE=`uname`
[[ $OSTYPE == "Linux" ]] && OSTYPE="linux"
[[ $OSTYPE == "Darwin" ]] && OSTYPE="macos"

#
# General Options
#

# Disable core dumps
limit coredumpsize 0

# Enable directory colours
[[ $OSTYPE == "linux" ]] && eval `dircolors -b ~/.dircolors`

#
# Environment Variables
#

LOCAL_PROMPT="[%n@%m %{[1;31m%}%(?..%?)%{[0m%}%~] "
REMOTE_PROMPT="[%n@%m %{[1;31m%}%(?..%?)%{[0m%}%~ %{[1;32m%}#%{[0m%}]"
export PATH="$HOME/bin:$HOME/bin/shared:${HOME}/.cabal/bin:$PATH:/opt/local/bin:/opt/local/maude"
export EDITOR="vim"
export LESS="-i -R -n -S -FRX"
export PYTHONSTARTUP="$HOME/.python"
# For C-semantics tool
export K_MAUDE_BASE="/opt/local/k-framework-svn-2880"

#
# Determine if we are a remote login
#
LOGIN_IP=`echo ${SSH_CLIENT} | cut -d ' ' -f 1`
echo $LOGIN_IP | egrep -q '^(10|192.168)\.'
if [[ $? == 0 ]]; then
	# Local IP address
	LOGIN_IP=""
fi

#
# Setup prompt
#
if [ $LOGIN_IP ] ; then
	export PROMPT=$REMOTE_PROMPT
else
	export PROMPT=$LOCAL_PROMPT
fi
export LOGIN_IP

#
# Aliases
#

alias ls="ls --color=auto"
alias grep="grep --color=always"
alias l="ls"
alias cp="cp -i"
alias mv="mv -i"
alias ll="ls -l"
alias la="ls -A"
alias vi="vim"
alias hist='fc -RI' # Import History
alias :q=exit

# ZSH Options

#setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY
unsetopt LIST_AMBIGUOUS
setopt AUTO_LIST
setopt AUTO_MENU
setopt AUTO_REMOVE_SLASH
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_NO_STORE
setopt EXTENDED_HISTORY
setopt INTERACTIVE_COMMENTS
setopt LIST_TYPES
setopt LONG_LIST_JOBS
setopt NO_HUP
setopt RC_QUOTES
export HISTFILE="${HOME}/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000

# Mouse Support

if [ -e ~/.zsh/mouse.zsh ]; then
	. ~/.zsh/mouse.zsh
	bindkey -M emacs '\em' zle-toggle-mouse
fi

# Key Bindings

bindkey -e
bindkey '\e[1~' beginning-of-line
bindkey '\e[2~' overwrite-mode
bindkey '\e[3~' delete-char
bindkey '\e[4~' end-of-line
bindkey '\e[5~' beginning-of-history
bindkey '\e[6~' end-of-history
bindkey '\e[5C' forward-word
bindkey '\e[5D' backward-word
bindkey '\e\e[5C' forward-word
bindkey '\e\e[5D' backward-word

# Allow custom completion

fpath=(~/.zsh $fpath)
autoload -U ~/.zsh/*(:t)

setopt PROMPT_SUBST
function vcs_prompt {
    git branch &>/dev/null && \
     echo -n '-git-' && \
     git branch | grep '^*' | cut -d ' ' -f 2 && \
     return
    hg root &>/dev/null && \
     echo -n '-hg-' && \
     hg branch && \
     return
}
export RPROMPT=$'[%*$(vcs_prompt)]'

# Reload scripts
r() {
	local f
	f=(~/.zsh/*(.))
	unfunction $f:t 2> /dev/null
	autoload -U $f:t
}

# Completion

#autoload -U compinit
#compinit

zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-z}={A-Z} r:|[._-]=* r:|=*'
zstyle ':completion:*' menu select=2

zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''



#
# X-Term Title
#

case $TERM in
	(xterm*|putty*))
		precmd() {
			echo -n "\033]0;${USER}@${HOST}: zsh (${PWD})\007";
		}
		preexec() {
			COMMAND=`echo -n $1 | cat -v | sed 's/	/ /'`;
			echo -n "\033]0;${USER}@${HOST}: ${COMMAND} (${PWD})\007";
		}
		;;
	screen*)
		precmd() {
			echo -ne "\033]0;${USER}@${HOST}: zsh (${PWD})\007";
			echo -ne "\033k${USER}@${HOST}: zsh (${PWD})\033\\"; 
		}
		preexec() {
			COMMAND=`echo -n $1 | cat -v | sed 's/	/ /'`;
			echo -ne "\033]0;${USER}@${HOST}: ${COMMAND} (${PWD})\007";
			echo -ne "\033k${USER}@${HOST}: ${COMMAND} (${PWD})\033\\";
		}
		;;
	*)
		;;
esac

# Source any computer-local options

if [ -e ~/.zsh_local ]; then
	source ~/.zsh_local
fi


# Configure ssh-agent for gnome
export SSH_ASKPASS=gnome-ssh-askpass

# Check cron mail
mail -H &>/dev/null
if [[ $? == 0 ]]; then
    echo "You have unread mail."
fi

# Terminal highlighting.
highlight() { perl -pe "s/$1/\e[1;31;43m$&\e[0m/g"; }

