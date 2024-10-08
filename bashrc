# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples
# shellcheck disable=SC1091,SC2154

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
xterm-color | xterm-kitty | *-256color) color_prompt=yes ;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
	if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
		# We have color support; assume it's compliant with Ecma-48
		# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
		# a case would tend to support setf rather than setaf.)
		color_prompt=yes
	else
		color_prompt=
	fi
fi

if [ "$color_prompt" = yes ]; then
	PS1='${debian_chroot:+($debian_chroot)}\[\e[1;32m\][\[\e[1;34m\]\h\[\e[1;32m\]]\[\e[1;36m\]❮\[\e[1;35m\]| \[\e[1;33m\]\W \[\e[1;35m\]|\[\e[1;36m\]❯\[\e[0;32m\] '
else
	PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm* | rxvt*)
	PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
	;;
*) ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
	alias ls='colorls'
	#alias dir='dir --color=auto'
	#alias vdir='vdir --color=auto'

	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -lah'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

HOME="${HOME:-/home/salesloft}"
SH_NAME=$(basename "${SHELL}")
# shellcheck source=/home/salesloft
[[ -f "${HOME}/.${SH_NAME}_aliases" ]] && source "${HOME}/.${SH_NAME}_aliases"
# shellcheck source=/home/salesloft
[[ -f "${HOME}/.${SH_NAME}_envs" ]] && source "${HOME}/.${SH_NAME}_envs"

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
export TERM='xterm-256color'
export XDG_CONFIG_HOME="${HOME}/.config"

if [ "$(which ruby | wc -l)" -eq "0" ]; then
	sudo apt-get update -qq &&
		sudo apt-get install -qqy ruby-dev
fi

GEM_HOME="$(ruby -e 'puts Gem.user_dir')"
echo "gem: --user-install" >"${HOME}"/.gemrc
echo "gemhome: ${GEM_HOME}" >>"${HOME}"/.gemrc
export PATH="${GEM_HOME}/bin:${PATH}"

if [ "$(which colorls | wc -l)" -eq "0" ]; then
	gem install colorls || sudo gem install colorls
fi

if [ "$(which kitty | wc -l)" -eq "0" ]; then
	sudo apt-get update -qq &&
		sudo apt-get install -qqy kitty
fi

[[ -f "${HOME}/fzf-git.sh" ]] && source "${HOME}/fzf-git.sh"
