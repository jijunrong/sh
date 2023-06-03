#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
CONF="/etc/snell/snell-server.conf"
SYSTEMD="/etc/systemd/system/snell.service"

if cat /etc/*-release | grep -q -E -i "debian|ubuntu|armbian|deepin|mint"; then 	# install dependencies
	apt-get install wget unzip dpkg -y
elif cat /etc/*-release | grep -q -E -i "centos|red hat|redhat"; then
	yum install wget unzip dpkg -y
elif cat /etc/*-release | grep -q -E -i "arch|manjora"; then
	yes | pacman -S wget dpkg unzip
elif cat /etc/*-release | grep -q -E -i "fedora"; then
	dnf install wget unzip dpkg -y
fi


ARCHITECTURE=`uname -m`
if [ ${ARCHITECTURE} = "x86_64" ]
then
	ARCHITECTURE="amd64"
else
	ARCHITECTURE="aarch64"
fi


cd ~/

wget --no-check-certificate -O snell.zip https://dl.nssurge.com/snell/snell-server-v4.0.1-linux-$ARCHITECTURE.zip

unzip -o snell.zip

chmod +x snell-server


unzip -o snell.zip

chmod +x snell-server

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



echo "$(curl -s ipinfo.io/city) = snell, $(curl -s ipinfo.io/ip), $(cat /etc/snell/snell-server.conf | grep -i listen | cut --delimiter=':' -f2),psk=$(grep 'psk' /etc/snell/snell-server.conf | cut -d= -f2 | tr -d ' '), version=4, tfo=true"
