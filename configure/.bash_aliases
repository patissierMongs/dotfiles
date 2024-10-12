# .bash_aliases

# Systemctl aliases
alias slr='systemctl restart'
alias sls='systemctl status'
alias sle='systemctl enable'
alias slp='systemctl stop'
alias sld='systemctl disable'
alias slt='systemctl start'

# DNF/YUM aliases
alias di='dnf install -y'
alias dl='dnf download'

# SELinux & Firewalld aliases
alias ssf='systemctl stop firewalld'
alias sdf='systemctl disable firewalld'
alias Soff="sed -i 's/^SELINUX=.*/SELINUX=permissive/' /etc/selinux/config"
alias Son="sed -i 's/^SELINUX=.*/SELINUX=enforcing/' /etc/selinux/config'"

# General purpose aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias cls='clear'
alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'

# Network aliases
alias ports='netstat -tulanp'
alias ipinfo='ip addr show'

# Git aliases
alias gst='git status'
alias gco='git checkout'
alias gb='git branch'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log'

# Docker aliases
alias dcr='docker container run'
alias dra='docker remove -f $(docker container ls -aq)'
alias dls='docker ls'
