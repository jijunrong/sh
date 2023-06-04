#!/bin/bash

#########################################注意注意注意注意注意############################################

#蓝色
blue(){
    echo -e "\033[34m\033[01m$1\033[0m"
}
#绿色
green(){
    echo -e "\033[32m\033[01m$1\033[0m"
}
#红色
red(){
    echo -e "\033[31m\033[01m$1\033[0m"
}
#黄色
yellow(){
    echo -e "\033[33m\033[01m$1\033[0m"
}
#天蓝
grey(){
    echo -e "\033[36m\033[01m$1\033[0m"
}
#紫色
purple(){
    echo -e "\033[35m\033[01m$1\033[0m"
}
#白色
white(){
    echo -e "\033[37m\033[01m$1\033[0m"
}
#绿色背景
greenbg(){
    echo -e "\033[43;42m\033[01m $1 \033[0m"
}
#红色背景
redbg(){
    echo -e "\033[37;41m\033[01m $1 \033[0m"
}
#黄色背景
yellowbg(){
    echo -e "\033[33m\033[01m\033[05m[ $1 ]\033[0m"
}

#==================================================================================================
# 作者: JIJUNRONG
# 博客: https://blog.jijunrong.com/
#==================================================================================================
######################################################################################################



#plex一键脚本
function plex(){
wget -O "/root/plex.sh" "https://raw.githubusercontent.com/jijunrong/sh/main/plex.sh" --no-check-certificate -T 30 -t 5 -d
chmod +x "/root/plex.sh"
chmod 777 "/root/plex.sh"
blue "下载完成"
blue "输入 bash /root/plex.sh 来运行"
}



#一键DD脚本
function Debian(){
curl -fLO https://raw.githubusercontent.com/jijunrong/sh/main/debian.sh && chmod a+rx debian.sh
blue "下载完成"
blue "输入 sudo ./debian.sh --cdn --network-console --ethx --bbr --user root --password zxc1230. --version 12 来运行"
blue "下载完成后 运行 sudo shutdown -r now 重启VPS"
}


#获取本机IP
function getip(){
green "本地IP"
curl -s ipinfo.io/ip
grey
}


#Rclone官方一键安装脚本
function rc(){
curl https://rclone.org/install.sh | sudo bash
}


#安装snell
function snell(){
sudo bash -c "$(curl -sL https://raw.githubusercontent.com/jijunrong/sh/main/snell.sh)"
blue "snell安装完成"
}

#卸载snell
function rmsnell(){
sudo bash -c "$(curl -sL https://raw.githubusercontent.com/jijunrong/sh/main/rmsnell.sh)"
blue "snell卸载完成"
}

#安装xray
function xray(){
sudo bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install
blue "xray安装完成"
}

#卸载xray
function rmxray(){
sudo bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ remove --purge
blue "xray卸载完成"
}


#启动BBR FQ算法
function bbrfq(){
remove_bbr_lotserver
	echo "net.core.default_qdisc=fq" >> /etc/sysctl.d/99-sysctl.conf
	echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.d/99-sysctl.conf
	sysctl --system
	echo -e "BBR+FQ修改成功，重启生效！"
}


#设置时区
function timezone(){
	sudo timedatectl set-timezone Asia/Shanghai
}


#系统网络配置优化
function system-best(){
	sed -i '/net.ipv4.tcp_retries2/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_slow_start_after_idle/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_fastopen/d' /etc/sysctl.conf
	sed -i '/fs.file-max/d' /etc/sysctl.conf
	sed -i '/fs.inotify.max_user_instances/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_syncookies/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_fin_timeout/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_tw_reuse/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_max_syn_backlog/d' /etc/sysctl.conf
	sed -i '/net.ipv4.ip_local_port_range/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_max_tw_buckets/d' /etc/sysctl.conf
	sed -i '/net.ipv4.route.gc_timeout/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_synack_retries/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_syn_retries/d' /etc/sysctl.conf
	sed -i '/net.core.somaxconn/d' /etc/sysctl.conf
	sed -i '/net.core.netdev_max_backlog/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_timestamps/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_max_orphans/d' /etc/sysctl.conf
	sed -i '/net.ipv4.ip_forward/d' /etc/sysctl.conf

echo "net.ipv4.tcp_retries2 = 8
net.ipv4.tcp_slow_start_after_idle = 0
fs.file-max = 1000000
fs.inotify.max_user_instances = 8192
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_tw_reuse = 1
net.ipv4.ip_local_port_range = 1024 65000
net.ipv4.tcp_max_syn_backlog = 16384
net.ipv4.tcp_max_tw_buckets = 6000
net.ipv4.route.gc_timeout = 100
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_synack_retries = 1
net.core.somaxconn = 32768
net.core.netdev_max_backlog = 32768
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_max_orphans = 32768
# forward ipv4
#net.ipv4.ip_forward = 1">>/etc/sysctl.conf
sysctl -p
	echo "*               soft    nofile           1000000
*               hard    nofile          1000000">/etc/security/limits.conf
	echo "ulimit -SHn 1000000">>/etc/profile
	read -p "需要重启VPS后，才能生效系统优化配置，是否现在重启 ? [Y/n] :" yn
	[ -z "${yn}" ] && yn="y"
	if [[ $yn == [Yy] ]]; then
		echo -e "${Info} VPS 重启中..."
		reboot
	fi
}

#IP.SH ipv4/6优先级调整一键脚本·下载
function ip(){
wget -O "/root/ip.sh" "https://raw.githubusercontent.com/jijunrong/sh/main/main/ip.sh" --no-check-certificate -T 30 -t 5 -d
chmod +x "/root/ip.sh"
chmod 777 "/root/ip.sh"
blue "下载完成"
blue "输入 bash /root/ip.sh 来运行"
}

#更改语言环境中文
function zh_CN(){
sudo EDITOR='sed -Ei "
    s|locales/locales_to_be_generated=.+|locales/locales_to_be_generated=\"zh_CN.UTF-8 UTF-8\"|; 
    s|locales/default_environment_locale=.+|locales/default_environment_locale=\"zh_CN.UTF-8\"|
    "' dpkg-reconfigure -f editor locales
}

#恢复语言默认环境
function en_US(){
sudo EDITOR='sed -Ei "
    s|locales/locales_to_be_generated=.+|locales/locales_to_be_generated=\"en_US.UTF-8 UTF-8\"|; 
    s|locales/default_environment_locale=.+|locales/default_environment_locale=\"en_US.UTF-8\"|
    "' dpkg-reconfigure -f editor locales
}

#更改主机名称
function vpsname(){
    read -p "输入你的更改主机名称:" name
	sudo hostnamectl set-hostname $name
}


#主菜单
function start_menu(){
    clear
    red " ONE 集合" 
    green " 来自: https://blog.jijunrong.com/ "
    green " 帮助: https://blog.jijunrong.com/ "
    green " 食用方法:  wget -O one.sh https://raw.githubusercontent.com/jijunrong/sh/main/one.sh && chmod +x one.sh && clear && ./one.sh "
    yellow " =================================================="
    green " 1. PLEX一键脚本" 
    green " 2. 一键DD脚本"
    green " 3. 安装snell"
    green " 4. 卸载snell" 
    green " 5. 安装xray"
    green " 6. 卸载xray"
    green " 7. 设置时区为Asia/Shanghai"
    yellow " --------------------------------------------------"
    green " 11. 获取本机IP"
    green " 12. ipv4/6优先级调整" 
    green " 13. 启动BBR FQ算法"
    green " 14. 系统网络配置优化"
    green " 15. 更改语言环境中文"
    green " 16. 恢复语言默认环境"
    green " 17. 更改主机名称" 
    green " 18. SWAP一键安装/卸载脚本"

    yellow " --------------------------------------------------"

    yellow " --------------------------------------------------"

    green " 32. Rclone官方一键安装脚本"

    yellow " =================================================="
    green " 0. 退出脚本"
    echo
    read -p "请输入数字:" menuNumber
    case "$menuNumber" in
        1 )
           plex
	;;
        2 )
           Debian
	;;
        3 )
           snell
	;;
        4 )
           rmsnell
	;;
        5 )
           xray
	;;
	6 )
           rmxray
	;;
	7 )
           timezone
	;;
	11 )
           getip
	;;
	12 )
           ip
	;;
	13 )
           bbrfq
	;;
	14 )
           system-best
	;;
	15 )
           zh_CN
	;;
	16 )
           en_US
	;;
	17 )
           vpsname
	;;
	18 )
           swapsh
	;;

	32 )
           rc
	;;
        33 )
           aria
	;;

        0 )
            exit 1
        ;;
        * )
            clear
            red "请输入正确数字 !"
            start_menu
        ;;
    esac
}

start_menu "first"
