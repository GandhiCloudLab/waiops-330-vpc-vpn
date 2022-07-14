#!/usr/bin/env bash
date1=$(date '+%Y-%m-%d-%H-%M-%S')

source ./01-config-virtualserver.sh

echo "----------------------------------------------------------------------"
echo "Copying scripts to VM : Process started : " + $date1
echo "----------------------------------------------------------------------"

## Define folder and file names
SCRIPTS_FOLDER=./temp
## My VM
VM_IPADDRESS=$VPN_PEER_IP

VM_FOLDER=/root/ibm/vpn-setup

SCRIPT_TAR_FILE_NAME=scripts.tar
SCRIPT_TAR_FILE_NAME_ONLY=scripts
echo "------------------- 1 -----------------------"
echo "Local folder : $SCRIPTS_FOLDER"
echo "Target folder : $VM_FOLDER"
echo "Target VM : $VM_IPADDRESS"
echo "Tar file : $SCRIPT_TAR_FILE_NAME"
echo "------------------------------------------"

## Create Tar file in Local
rm -rf $SCRIPTS_FOLDER
# read -p "	Process completed. Press Enter to continue "

mkdir -p $SCRIPTS_FOLDER
# cp 00-config.sh $SCRIPTS_FOLDER
chmod 777 01-config-virtualserver.sh
chmod 777 02-config-gateway.sh

cp 01-config-virtualserver.sh $SCRIPTS_FOLDER
cp 02-config-gateway.sh $SCRIPTS_FOLDER
cp 17-install-in-virtualserver.sh $SCRIPTS_FOLDER

cd $SCRIPTS_FOLDER
tar -cvf ${SCRIPT_TAR_FILE_NAME} .
chmod 777  ${SCRIPT_TAR_FILE_NAME}
echo "------------------- 2 -----------------------"
echo "Tar file created in local"
ls -l
echo "------------------------------------------"

## Create Target folder in VM
echo "------------------- 3 -----------------------"
echo "Create Target and backup folder in VM"
echo "------------------------------------------"
ssh root@${VM_IPADDRESS} << EOF
    rm -rf ${VM_FOLDER}
    mkdir -p ${VM_FOLDER}
EOF

## Copy Tar file to Target folder in VM
echo "------------------- 4 -----------------------"
echo "Copy file to Target folder in VM "
echo "------------------------------------------"
scp $SCRIPT_TAR_FILE_NAME root@${VM_IPADDRESS}:${VM_FOLDER}

## UnTar the tar file in VM
echo "------------------- 4 -----------------------"
echo " UnTar the tar file in VM "
ssh root@${VM_IPADDRESS} << EOF
    cd ${VM_FOLDER}
    tar -xvf ${SCRIPT_TAR_FILE_NAME}
    ls -l
EOF
echo "------------------------------------------"

date1=$(date '+%Y-%m-%d-%H-%M-%S')
echo "==================================================================="
echo "Copying scripts to VM : Process completed : " + $date1
echo "==================================================================="
