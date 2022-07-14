#!/bin/bash

source ./00-config.sh

echo "----------------------------------------------------------------------"
echo " 1. ibmcloud Login "
echo "----------------------------------------------------------------------"
## 1. Log in your account:
ibmcloud login --apikey $IBMCLOUD_API_KEY

### Target Region
ibmcloud target -r $REGION

## 2. Target Generation 2 infrastructure: 
ibmcloud is target --gen 2


echo "----------------------------------------------------------------------"
echo " 2.  RESOURCE_GROUP "
echo "----------------------------------------------------------------------"
### Get resource group id
RESOURCE_GROUP_ID=$(ibmcloud resource groups | grep ${RESOURCE_GROUP} | awk '{print $2}')
### Set the target to the created resource group
ibmcloud target -g $RESOURCE_GROUP_ID

