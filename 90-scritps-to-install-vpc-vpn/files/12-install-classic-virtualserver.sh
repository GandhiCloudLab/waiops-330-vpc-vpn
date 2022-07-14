#!/bin/bash

source ./00-config.sh

echo "******************************************************************************************"
echo " Virtual Server Instance creation in Classic Infra started ....$date1"
echo "******************************************************************************************"

echo "----------------------------------------------------------------------"
echo " 1. ibmcloud Login "
echo "----------------------------------------------------------------------"
## 1. Log in your account:
ibmcloud login --apikey $IBMCLOUD_API_KEY

### Target Region
ibmcloud target -r $JUMP_BOX_REGION


echo "----------------------------------------------------------------------"
echo " 2. Create RESOURCE_GROUP and target it "
echo "----------------------------------------------------------------------"
### Create resource group
# ibmcloud resource group-create $JUMP_BOX_RESOURCE_GROUP

### Get resource group id
JUMP_BOX_RESOURCE_GROUP_ID=$(ibmcloud resource groups | grep ${JUMP_BOX_RESOURCE_GROUP} | awk '{print $2}')

echo " JUMP_BOX_RESOURCE_GROUP: $JUMP_BOX_RESOURCE_GROUP"
echo " JUMP_BOX_RESOURCE_GROUP_ID: $JUMP_BOX_RESOURCE_GROUP_ID"

### Set the target to the created resource group
ibmcloud target -g $JUMP_BOX_RESOURCE_GROUP_ID


echo "----------------------------------------------------------------------"
echo " 3. Get SSH KEY ID "
echo "----------------------------------------------------------------------"
### Get ssh key id 1
JUMP_BOX_SSH_KEY_ID1=$(ibmcloud sl security sshkey-list  | grep ${JUMP_BOX_SSH_KEY1} | awk '{print $1}')
echo " JUMP_BOX_SSH_KEY1: $JUMP_BOX_SSH_KEY1"
echo " JUMP_BOX_SSH_KEY_ID1: $JUMP_BOX_SSH_KEY_ID1"

### Get ssh key id 2
JUMP_BOX_SSH_KEY_ID2=$(ibmcloud sl security sshkey-list  | grep ${JUMP_BOX_SSH_KEY2} | awk '{print $1}')
echo " JUMP_BOX_SSH_KEY2: $JUMP_BOX_SSH_KEY2"
echo " JUMP_BOX_SSH_KEY_ID2: $JUMP_BOX_SSH_KEY_ID2"


echo "----------------------------------------------------------------------"
echo " 4. Create Virtual Server "
echo "----------------------------------------------------------------------"
### Create Virtual Server
ibmcloud sl vs create -H $JUMP_BOX_NAME -D $JUMP_BOX_DOMAIN -c $JUMP_BOX_CPU -m $JUMP_BOX_MEMORY -d $JUMP_BOX_ZONE -o $JUMP_BOX_OS --key $JUMP_BOX_SSH_KEY_ID1 

### Get Virtual Server id
JUMP_BOX_SERVER_ID=$(ibmcloud sl vs list | grep ${JUMP_BOX_NAME} | awk '{print $1}')
echo "JUMP_BOX_SERVER_ID : $JUMP_BOX_SERVER_ID"

echo "----------------------------------------------------------------------"
echo " 5. Print Virtual Server Details"
echo "----------------------------------------------------------------------"
### Print Virtual Server Details
ibmcloud sl vs detail $JUMP_BOX_SERVER_ID

date1=$(date '+%Y-%m-%d %H:%M:%S')
echo "******************************************************************************************"
echo " Virtual Server Instance creation in Classic Infra Completed ....$date1"
echo "******************************************************************************************"
