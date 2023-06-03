#!/bin/bash

#停止进程。
systemctl stop snell.service
#取消开机启动进程。
systemctl disable snell.service
#删除snell守护进程。
rm -rf /etc/systemd/system/snell.service
#删除snell程序。
rm -rf /usr/local/bin/snell-server
#删除snell配置文件夹。
rm -rf /etc/snell/
