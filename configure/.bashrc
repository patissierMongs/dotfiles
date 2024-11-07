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

PS1='\[\e[38;5;66m\]\u@\h \[\e[38;5;116m\]\w\[\e[38;5;136m\] \$ \[\e[0m\]'

export LS_COLORS="di=38;5;116:fi=38;5;66:ln=38;5;109:so=38;5;222:pi=38;5;215:bd=38;5;67:cd=38;5;67:or=38;5;209:ex=38;5;141:"

alias ls='ls --color=auto'
alias ll='ls -alF --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

export GREP_COLOR='38;5;174'
export GREP_OPTIONS='--color=auto'



if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -f ~/.vimrc ]; then
    . ~/.vimrc
fi
