#!/bin/bash

systemctl stop snell.service
systemctl disable snell.service
rm -f /etc/systemd/system/snell.service
rm -f /usr/local/bin/snell-server
rm -f /etc/snell/snell-server.conf
