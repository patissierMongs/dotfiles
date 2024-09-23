# aliases
alias slr='systemctl restart'
alias sls='systemctl status'
alias sle='systemctl enable'
alias slp='systemctl stop'
alias sld='systemctl disable'
alias slt='systemctl start'
alias di='dnf install'
alias dl='dnf download'

# SELINUX & Firewalld
alias ssf='systemctl stop firewalld'
alias sdf='systemctl disable firewalld'
alias Soff="sed -i 's/^SELINUX=.*/SELINUX=permissive/' /etc/selinux/config"
alias Son="sed -i 's/^SELINUX=.*/SELINUX=enforcing/' /etc/selinux/config"
