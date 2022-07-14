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
