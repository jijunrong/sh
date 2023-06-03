#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
CONF="/etc/snell/snell-server.conf"
SYSTEMD="/etc/systemd/system/snell.service"
ARCH=$(uname -m)

#判定系统，并下载必要的插件！
if cat /etc/*-release | grep -q -E -i "debian|ubuntu|armbian|deepin|mint"; then 	# install dependencies
	apt-get install wget unzip dpkg -y
elif cat /etc/*-release | grep -q -E -i "centos|red hat|redhat"; then
	yum install wget unzip dpkg -y
elif cat /etc/*-release | grep -q -E -i "arch|manjora"; then
	yes | pacman -S wget dpkg unzip
elif cat /etc/*-release | grep -q -E -i "fedora"; then
	dnf install wget unzip dpkg -y
fi

case $ARCH in
    aarch64 | armv8)
     match="linux-aarch64"
     ;;
    armv7 | armv6l)
     match="linux-armv7l"
     ;;
     *) #x86_64
      match="linux-amd64"
     ;;
esac


cd ~/
#下载链接
#把获取的变量值带入链接下载，并重命名下载文件名字。
wget --no-check-certificate -O snell.zip https://dl.nssurge.com/snell/snell-server-v4.0.1-$match.zip

#解压下载文件。
unzip -o snell.zip

#赋予程序执行权限。
chmod +x snell-server

#移动程序到/usr/local/bin/文件夹下。
mv snell-server /usr/local/bin/

 if [ -f ${CONF} ]; then
   echo "找到配置文件..."
   else
   if [ -z ${PSK} ]; then
     PSK=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 16)
     echo "生成新的 PSK: ${PSK}"
   else
     echo "使用旧的 PSK: ${PSK}"
   fi
   mkdir /etc/snell/
   echo "生成新的配置文件..."
   echo "[snell-server]" >>${CONF}
   echo "listen = 0.0.0.0:8888" >>${CONF}
   echo "psk = ${PSK}" >>${CONF}
   echo "obfs = tls" >>${CONF}
 fi
 if [ -f ${SYSTEMD} ]; then
   echo "找到snell守护进程..."
   systemctl daemon-reload
   systemctl restart snell
 else
   echo "生成snell守护进程..."
   echo "[Unit]" >>${SYSTEMD}
   echo "Description=Snell Proxy Service" >>${SYSTEMD}
   echo "After=network.target" >>${SYSTEMD}
   echo "" >>${SYSTEMD}
   echo "[Service]" >>${SYSTEMD}
   echo "Type=simple" >>${SYSTEMD}
   echo "LimitNOFILE=8888" >>${SYSTEMD}
   echo "ExecStart=/usr/local/bin/snell-server -c /etc/snell/snell-server.conf" >>${SYSTEMD}
   echo "" >>${SYSTEMD}
   echo "[Install]" >>${SYSTEMD}
   echo "WantedBy=multi-user.target" >>${SYSTEMD}
   systemctl daemon-reload
   systemctl enable snell
   systemctl start snell
 fi


#生成snell节点内容。
echo "$(uname -n) = snell, $(curl -s ipinfo.io/ip), $(cat /etc/snell/snell-server.conf | grep -i listen | cut --delimiter=':' -f2),psk=$(grep 'psk' /etc/snell/snell-server.conf | cut -d= -f2 | tr -d ' '), version=4, tfo=true"
