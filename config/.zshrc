
#
# .zshrc
#
# 2010-2012 Matthew Fernandez
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

LOCAL_PROMPT="[%n@%m %{[1;31m%}%(?..%? )%{[0m%}%~] "
REMOTE_PROMPT="[%n@%m %{[1;31m%}%(?..%?)%{[0m%}%~ %{[1;32m%}#%{[0m%}]"
export PATH="$HOME/bin:$PATH"
export EDITOR="vim"
export LESS="-i -R -n -S -FRX"
export PYTHONSTARTUP="$HOME/.python"

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
alias :Q=exit
alias tmp='pushd `mktemp -d`'
alias cim=vim # Cope with my typos.
alias evince="dbus-launch /usr/bin/evince" # Mask evince problems in newer Ubuntu.
function wim() {
    if [ $# -gt 0 ]; then
        vim `which $1`;
    else
        vim;
    fi
}

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
export HISTSIZE=1000000
export SAVEHIST=1000000

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

# Prompt foreground colour shortcuts.
NORMAL="%{[0m%}"
BLACK="%{[1;30m%}"
RED="%{[1;31m%}"
GREEN="%{[1;32m%}"
YELLOW="%{[1;33m%}"
BLUE="%{[1;34m%}"
MAGENTA="%{[1;35m%}"
CYAN="%{[1;36m%}"
WHITE="%{[1;37m%}"

# Version control status.
setopt PROMPT_SUBST
function vcs_prompt {
    for i in git hg svn; do
        which $i &>/dev/null
        if [ $? -ne 0 ]; then
            echo "zshrc: $i not found; vcs_prompt bailing out." 1>&2
            exit 1
        fi
    done
    timeout 1 git branch &>/dev/null
    if [ $? -eq 0 ]; then
        echo -n '-git-'
        if [ -z "`timeout 1 git status --short 2>/dev/null`" ]; then
            # Working directory is clean.
            echo -n "${GREEN}"
        elif [ -z "`timeout 1 git status --short 2>/dev/null | grep -v '^?'`" ]; then
            # Working directory only contains changes to untracked files.
            echo -n "${YELLOW}"
        else
            # Working directory contains changes to tracked files.
            echo -n "${RED}"
        fi
        echo -n `timeout 1 git branch 2>/dev/null | grep '^*' | cut -d ' ' -f 2`
        echo -n "${NORMAL}"
    fi
    timeout 1 hg root &>/dev/null
    if [ $? -eq 0 ]; then
        echo -n '-hg-'
        if [ -z "`timeout 1 hg status 2>/dev/null`" ]; then
            # Working directory is clean.
            echo -n "${GREEN}"
        elif [ -z "`timeout 1 hg status 2>/dev/null | grep -v '^?'`" ]; then
            # Working directory only contains changes to untracked files.
            echo -n "${YELLOW}"
        else
            # Working directory contains changes to tracked files.
            echo -n "${RED}"
        fi
        echo -n `timeout 1 hg branch 2>/dev/null`
        echo -n "${NORMAL}"
    fi
    timeout 1 svn list &>/dev/null
    if [ $? -eq 0 ]; then
        echo -n '-svn-'
        if [ -z "`timeout 1 svn status 2>/dev/null`" ]; then
            # Working directory is clean.
            echo -n "${GREEN}"
        elif [ -z "`timeout 1 svn status 2>/dev/null | grep -v '^?'`" ]; then
            # Working directory only contains changes to untracked files.
            echo -n "${YELLOW}"
        else
            # Working directory contains changes to tracked files.
            echo -n "${RED}"
        fi
        echo -n `timeout 1 svn info 2>/dev/null | grep URL | sed 's/.*\/\(.*\)/\1/g'`
        echo -n "${NORMAL}"
    fi
}
export RPROMPT=$'[${RED}$(jobs | wc -l | grep -v "^0")${NORMAL}%*$(vcs_prompt)]'

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

if [ -e ~/.zshrc_local ]; then
	source ~/.zshrc_local
fi
if [ -e ~/.zshrc_mattbin ]; then
    source ~/.zshrc_mattbin
fi
if [ -e ~/.zshrc_nictabin ]; then
    source ~/.zshrc_nictabin
fi


# Configure ssh-agent for gnome
export SSH_ASKPASS=gnome-ssh-askpass

# Check cron mail
mail -H &>/dev/null
if [[ $? == 0 ]]; then
    echo "You have unread mail."
fi

# Terminal highlighting.
highlight() { perl -pe "s/$1/\e[1;35;44m$&\e[0m/g"; }

if [[ "${TERM}" != "screen" ]]; then
    echo "You are not in screen/tmux..."
fi

# Ubuntu-style Command not found helper.
if [ -f /etc/zsh_command_not_found ]; then
    . /etc/zsh_command_not_found
fi

# \<forall> helper.
function _forall() {
    TYPE=$1
    shift
    find . -type ${TYPE} \
        ! -name '.' \
        ! -path '*/.hg/*'  ! -name '.hg'  ! -name '.hgkeep'  ! -name '.hgignore' \
        ! -path '*/.git/*' ! -name '.git' ! -name '.gitkeep' ! -name '.gitignore' \
        ! -path '*/.svn/*' ! -name '.svn' ! -name '.svnkeep' \
        ! -path '*/.cvs/*' ! -name '.cvs' ! -name '.cvskeep' \
        ! -name '*.swp' \
        -exec $@ "{}" \;
}
function forall() {
    if [ $# -eq 0 ]; then
        _forall f echo
    else
        _forall f $@
    fi
}
function foralld() {
    if [ $# -eq 0 ]; then
        _forall d echo
    else
        _forall d $@
    fi
}

# Wrapper around vim to convert Isabelle symbols if possible.
function v() {
    which xsymbol.py &>/dev/null
    if [[ $? -eq 0 && "${1##*.}" = "thy" ]]; then
        xsymbol.py "$1" | tail --bytes=+`xsymbol.py /dev/null | wc -c` | view -c "set syntax=isabelle" -
    else
        vim "$1"
    fi
}
