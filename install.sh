#!/bin/bash

(yum update -y || apt-get update -y) 2>&-

(yum install -y unzip wget || apt-get install -y unzip wget) 2>&-

pkill v2ray$ >/dev/null 2>&1

cd /usr/local/src
rm -rf v2ray-* >/dev/null 2>&1
rm -rf /usr/local/sbin/v2* >/dev/null 2>&1
rm -rf /usr/local/bin/v2ray >/dev/null 2>&1
wget --no-check-certificate https://9709.wodemo.com/down/20180326/475711/v2ray-linux-64-3.14.zip
unzip v2ray-linux-64-3.14.zip
cd v2ray-v*
mkdir /usr/local/bin/v2ray
cp v2ray /usr/local/bin/v2ray/
cp v2ctl /usr/local/bin/v2ray/

echo ""
read -p "请输入v2ray端口(默认8080): " port

port=${port:-8080}

echo '{
  "inbound": {
    "port": '$port',
    "protocol": "vmess",
    "settings": {
      "clients": [
        {
          "id": "f80a70a1-9d36-18f9-56a8-79e4d6fc8019",
          "alterId": 32
        }
      ]
    },
    "streamSettings": {
      "network": "tcp",
      "tcpSettings": {
        "header": {
          "type": "http"
        }
      }
    }
  },
  "outbound": {
    "protocol": "freedom",
    "settings": {}
  }
}
' > /etc/v2ray.json

echo '#!/bin/bash
start() {
  nohup /usr/local/bin/v2ray/v2ray -config /etc/v2ray.json >/dev/null 2>&1 & 
}

stop() {
  pkill v2ray$
}

case "$1" in
    start)
        start 
        sleep 0.5
        if [[ "$?" == 0 ]]; then echo "v2ray已启动"; else echo "v2ray未启动"; fi ;;
    stop)
        stop
        sleep 0.2
        if [[ "$?" == 0 ]]; then echo "v2ray已停止"; fi ;;

    restart)
        stop
        sleep 0.2
        start ;;

    status)
        ps -ef | grep -v grep | grep v2ray --color=auto 
        netstat -lntp | grep v2ray;;
        
    remove)
        rm -rf /usr/local/bin/v2ray/
        rm -rf /usr/local/src/v2ray-* 
        rm -rf $0 ;;
        
    config)
        vim /etc/v2ray.json ;;

    *)
        echo "Usage: v2cmd {start|stop|restart|status|remove|config}"
        exit 1 ;;
esac
' > /usr/local/sbin/v2cmd
cd ~/
chmod +x /usr/local/sbin/v2cmd

echo ''
echo '你的id为: f80a70a1-9d36-18f9-56a8-79e4d6fc8019'
echo '你的端口: '$port''
echo ''

v2cmd
