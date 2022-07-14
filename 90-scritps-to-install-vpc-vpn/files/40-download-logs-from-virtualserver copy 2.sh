#!/usr/bin/env bash
date1=$(date '+%Y-%m-%d-%H-%M-%S')

source ./01-config-virtualserver.sh

echo "----------------------------------------------------------------------"
echo "Copying scripts to VM : Process started : " + $date1
echo "----------------------------------------------------------------------"

VM_IPADDRESS=$VPN_PEER_IP

## Copy Tar file to Target folder in VM
echo "------------------- 4 -----------------------"
echo "Copy log file from VM "
echo "------------------------------------------"
scp root@${VM_IPADDRESS}:/var/log/syslog ../data/output/syslog-$date1.log


date1=$(date '+%Y-%m-%d-%H-%M-%S')
echo "==================================================================="
echo "Copying scripts to VM : Process completed : " + $date1
echo "==================================================================="
