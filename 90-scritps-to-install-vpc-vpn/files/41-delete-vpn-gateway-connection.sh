#!/usr/bin/env bash
date1=$(date '+%Y-%m-%d-%H-%M-%S')

source ./00-config.sh

echo "----------------------------------------------------------------------"
echo "41-delete-vpn-gateway-connection : Process started : " + $date1
echo "----------------------------------------------------------------------"


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



echo "----------------------------------------------------------------------"
echo " 3.  DELETE VPN GATEWAY CONNECTION "
echo "----------------------------------------------------------------------"

VPN_GATEWAY=aiops-poc-vpc-vpn-gw-us-south-1
VPN_GW_CONNECTION_ID=$(ibmcloud is vpn-gateway-connections ${VPN_GATEWAY} | grep ${VPN_GATEWAY} | awk '{print $1}')
ibmcloud is vpn-gateway-connection-delete ${VPN_GATEWAY} ${VPN_GW_CONNECTION_ID}

VPN_GATEWAY=aiops-poc-vpc-vpn-gw-us-south-2
VPN_GW_CONNECTION_ID=$(ibmcloud is vpn-gateway-connections ${VPN_GATEWAY} | grep ${VPN_GATEWAY} | awk '{print $1}')
ibmcloud is vpn-gateway-connection-delete ${VPN_GATEWAY} ${VPN_GW_CONNECTION_ID}

VPN_GATEWAY=aiops-poc-vpc-vpn-gw-us-south-3
VPN_GW_CONNECTION_ID=$(ibmcloud is vpn-gateway-connections ${VPN_GATEWAY} | grep ${VPN_GATEWAY} | awk '{print $1}')
echo "VPN_GW_CONNECTION_ID : $VPN_GW_CONNECTION_ID"
ibmcloud is vpn-gateway-connection-delete ${VPN_GATEWAY} ${VPN_GW_CONNECTION_ID}

ibmcloud is vpn-gateway-connection-delete ${VPN_GATEWAY} 0727-50cde567-e305-4c83-a232-ea8caa9a49a4


date1=$(date '+%Y-%m-%d-%H-%M-%S')
echo "==================================================================="
echo "41-delete-vpn-gateway-connection : Process completed : " + $date1
echo "==================================================================="
