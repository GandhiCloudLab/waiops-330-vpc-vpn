#!/bin/bash

source ./00-config.sh

echo "******************************************************************************************"
echo " Create and Assign Security Group in Virtual Server Instance in Classic Infra started ....$date1"
echo "******************************************************************************************"

### NOTE: This should be installed only of the Virtual server has public VLAN assigned as part of the provisioning.

echo "----------------------------------------------------------------------"
echo " 1. ibmcloud Login "
echo "----------------------------------------------------------------------"
## 1. Log in your account:
ibmcloud login --apikey $IBMCLOUD_API_KEY

### Target Region
ibmcloud target -r $JUMP_BOX_REGION


echo "----------------------------------------------------------------------"
echo " 2. Get RESOURCE_GROUP and target it"
echo "----------------------------------------------------------------------"
### Get resource group id
JUMP_BOX_RESOURCE_GROUP_ID=$(ibmcloud resource groups | grep ${JUMP_BOX_RESOURCE_GROUP} | awk '{print $2}')
echo " JUMP_BOX_RESOURCE_GROUP: $JUMP_BOX_RESOURCE_GROUP"
echo " JUMP_BOX_RESOURCE_GROUP_ID: $JUMP_BOX_RESOURCE_GROUP_ID"

### Set the target to the created resource group
ibmcloud target -g $JUMP_BOX_RESOURCE_GROUP_ID


echo "----------------------------------------------------------------------"
echo " 3. Create SECURITY GROUP "
echo "----------------------------------------------------------------------"
### Create security group
ibmcloud sl securitygroup create -n $JUMP_BOX_SECURITY_GROUP

### Get security group id
JUMP_BOX_SECURITY_GROUP_ID=$(ibmcloud sl securitygroup list | grep ${JUMP_BOX_SECURITY_GROUP} | awk 'NR==1{print $1}')
echo "JUMP_BOX_SECURITY_GROUP_ID : $JUMP_BOX_SECURITY_GROUP_ID"

echo "JUMP_BOX_REMOTE_IP1 : $JUMP_BOX_REMOTE_IP1"
echo "JUMP_BOX_REMOTE_IP2 : $JUMP_BOX_REMOTE_IP2"

### Add rule in to security for Remote IP 1 and 2
ibmcloud sl securitygroup rule-add $JUMP_BOX_SECURITY_GROUP_ID --remote-ip $JUMP_BOX_REMOTE_IP1 --direction ingress --port-max 22 --port-min 22  --protocol tcp
ibmcloud sl securitygroup rule-add $JUMP_BOX_SECURITY_GROUP_ID --remote-ip $JUMP_BOX_REMOTE_IP2 --direction ingress --port-max 22 --port-min 22  --protocol tcp


echo "----------------------------------------------------------------------"
echo " 4. Get Virtual Server ID"
echo "----------------------------------------------------------------------"
### Get Virtual Server id
JUMP_BOX_SERVER_ID=$(ibmcloud sl vs list | grep ${JUMP_BOX_NAME} | awk '{print $1}')
echo "JUMP_BOX_SERVER_ID : $JUMP_BOX_SERVER_ID"


echo "----------------------------------------------------------------------"
echo " 5. Assign SECURITY GROUP to Virtual Server "
echo "----------------------------------------------------------------------"
### Assign SECURITY GROUP to Virtual Server
ibmcloud sl securitygroup interface-add $JUMP_BOX_SECURITY_GROUP_ID --server $JUMP_BOX_SERVER_ID  --interface public

echo "----------------------------------------------------------------------"
echo " 6. Print Virtual Server Details"
echo "----------------------------------------------------------------------"
### Print Virtual Server Details
ibmcloud sl vs detail $JUMP_BOX_SERVER_ID

date1=$(date '+%Y-%m-%d %H:%M:%S')
echo "******************************************************************************************"
echo " Create and Assign Security Group in Virtual Server Instance in Classic Infra Completed ....$date1"
echo "******************************************************************************************"
