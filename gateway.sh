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


grey "======================================== 更换网关 ========================================"


oldgateway=$(cat /etc/NetworkManager/system-connections/eth0.nmconnection|cut -d , -f 2 |sed -n 12p)


old=192.168.50.50

new=192.168.50.30


green "原网关 $oldgateway"

#获取网站状态码
if [ "$oldgateway" = "$old" ]
#开始判断值是否等于200
then
#若等于，则输出
    sudo sed -i "s/${oldgateway}/${new}/g" /etc/NetworkManager/system-connections/eth0.nmconnection

else
#若不等于，则输出
    sudo sed -i "s/${oldgateway}/${old}/g" /etc/NetworkManager/system-connections/eth0.nmconnection
fi
#结束判断

newgateway=$(cat /etc/NetworkManager/system-connections/eth0.nmconnection|cut -d , -f 2 |sed -n 12p)

yellow "新网关 $newgateway"

white "重启网络设备"

nmcli connection down eth0 && nmcli connection up eth0 && systemctl restart NetworkManager.service && ip link set eth0 down && ip link set eth0 up

exit
