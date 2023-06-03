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
#====================== 用途：用于自动筛选CF代理IP，并自动替换优选IP到Surge配置文件 ======================
# 作者: JIJUNRONG
# 博客: https://blog.jijunrong.com/
#==================================================================================================
######################################################################################################

grey "======================================== 优选IP ========================================"


green  "============= 用途：用于自动筛选CF代理IP 并自动替换优选IP到Surge的配置文件 ============="

#获取开始时间
starttime=`date +'%Y-%m-%d %H:%M:%S'`

############################################删除优选IP包###################################


#white "======================================= 删除IP包 ======================================="

#删除IP压缩包，IP文件夹，IP文件。
sleep 1

############################################下载优选IP包###################################

#red "======================================= 下载IP包 ======================================="

#合并IP包为单一文件，并复制到运行文件夹下,并退到root文件夹下
#cd IP && cd ip && cat *.txt>>ip.txt && cp ip.txt /root/CF && cd


########################################开始执行优选####################################################

purple "======================================= 网络状态 ======================================="

#删除获取到的公网ip
rm -rf /root/temp.txt

#获取公网ip,并输出到temp.txt
curl ipinfo.io -o /root/temp.txt


publicip=$(cat /root/temp.txt|cut -f 4 -d '"'|sed -n 2p)

country=$(cat /root/temp.txt|cut -f 4 -d '"'|sed -n 5p)

#提取公网ip变量
grey "国家 $country 公网IP $publicip"

#一秒后启动
sleep 1

#获取网站状态
o=$(curl -s -o /dev/null --connect-timeout 2 -w "%{http_code}" https://www.google.com/)
#获取网站状态码
if [ "$o" = "200" ]
#开始判断值是否等于200
then
#若等于，则输出
    greenbg "网络状态: 科学冲浪"

else
#若不等于，则输出
    redbg "网络状态: 闭关锁国"
    
#结束判断,并输出状态在命令行
fi

#执行cloudflareST主程序

/root/CF/CloudflareST -n 1000 -tl 300 -tll 20 -sl 10 -f /root/CF/ip.txt

#2秒后启动
sleep 2

#删除speed.txt
#rm -rf /root/CF/speed.txt


#打印前三行｜第一列第六列并以，为分隔符|第二行并输出优选ip结果到speed.txt
#cat /root/result.csv|head -n 3|cut -d , -f 1,6 |sed -n 2p  >> /root/CF/speed.txt

cat /root/result.csv|cut -d , -f 1,6 |sed -n 1p  >> /root/优选IP.txt
cat /root/result.csv|cut -d , -f 1,6 |sed -n 2p  >> /root/优选IP.txt
cat /root/result.csv|cut -d , -f 1,6 |sed -n 3p  >> /root/优选IP.txt

#打印第一行第一第六列并输出优选ip结果到speed.txt，存作日志。

########################################获取优选IP####################################################

white "======================================= 获取 IP ======================================="

#删除获取到的公网ip
rm -rf /root/temp.txt

#获取公网ip,并输出到temp.txt
curl ipinfo.io -o /root/temp.txt

#提取公网ip
newpublicip=$(cat /root/temp.txt|cut -f 4 -d '"'|sed -n 2p)

#提取公网IP国家地区
newcountry=$(cat /root/temp.txt|cut -f 4 -d '"'|sed -n 5p)


#提取公网ip变量
grey "国家 $newcountry 公网IP $newpublicip"


#提取优选ip地址
IP=$(cat /root/result.csv|cut -d , -f 1 |sed -n 2p)

red "优选IP $IP"

#提取优选IP网速
speed=$(cat /root/result.csv|cut -d , -f 6 |sed -n 2p)

white "实测带宽 $speed Mb/s"

#提取优选IP网速
time=$(cat /root/result.csv|cut -d , -f 5 |sed -n 2p)

yellow "网络延迟 $time ms"

#########################################替换优选IP###################################################

blue "======================================= 替换 IP ======================================="

#获取surge配置文件第10行：后面的ip地址
Surge=$(cat ONE.conf|cut -d , -f 2 |sed -n 90p)

green "Surge 原生IP $Surge"
sleep 1
sudo sed -i "s/${Surge}/ ${IP}/g" ONE.conf
#替换Surge ip
sleep 1
clash=$(cat ONE.conf|cut -d , -f 2 |sed -n 90p)
#再次获取Surge ip
yellow "Surge 优选IP $clash"

###########################################结束优选IP#################################################



####################################登陆MAC并执行替换配置文件#######################################

grey "=============================== 登陆MAC执行替换配置文件 ==============================="

ssh mac@192.168.50.30 "scp root@192.168.50.60:/root/ONE.conf /Users/mac/Downloads/"

#登陆MAC并执行替换配置文件。
###########################################结束脚本###################################################


start_seconds=$(date --date="$starttime" +%s) #获取开始时间变量
endtime=`date +'%Y-%m-%d %H:%M:%S'` #获取结束时间
end_seconds=$(date --date="$endtime" +%s) #结束时间变量
purple "总计用时 $((end_seconds-start_seconds)) 秒"

exit
#退出脚本
