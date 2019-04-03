#!/bin/bash
echo '#!/bin/bash
#/bin/vy
pgrep -a v2ray | grep -w ./v2ray | grep $1 | awk '{print $1}' | xargs kill >/dev/null 2>&1
sleep 0.2
nohup ./v2ray -config $1 &> ${2:-/dev/null} &' > /usr/local/sbin/vy
chmod +x /usr/local/sbin/vy

echo '#!/bin/bash
#/bin/ipt
iptables -t ${1:-nat} -S' > /usr/local/sbin/ipt
chmod +x /usr/local/sbin/ipt

echo "
# alias
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -laF'
alias ls='ls --color=auto'
alias nets='netstat -lntp'
alias snets='sudo netstat -lntp'
alias sta='systemctl start'
alias sto='systemctl stop'
alias stu='systemctl status'
alias restart='systemctl restart'
alias tl='tail -f'
alias vp='vim /usr/local/haproxy-lkl/etc/port-rules'

# PS1
export PS1='\[\e[35;1m\]\u@\h \w \$ \[\e[0m\]'" >> ~/.bashrc
. ~/.bashrc 
