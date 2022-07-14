#!/bin/bash

source ./00-config.sh
source ./01-config-virtualserver.sh

echo "----------------------------------------------------------------------"
echo " 1. ibmcloud Login"
echo "----------------------------------------------------------------------"

## 1. Log in your account:
ibmcloud login --apikey $IBMCLOUD_API_KEY

### Target Region
ibmcloud target -r $REGION

### Get resource group id
RESOURCE_GROUP_ID=$(ibmcloud resource groups | grep -E "${RESOURCE_GROUP}(\s|$)" | awk '{print $2}')
echo " RESOURCE_GROUP: $RESOURCE_GROUP"
echo " RESOURCE_GROUP_ID: $RESOURCE_GROUP_ID"

### Set the target to the created resource group
ibmcloud target -g $RESOURCE_GROUP_ID

echo "----------------------------------------------------------------------"
echo " 2. Retrieve VPC_ID, ZONES, SUBNET_IDS "
echo "----------------------------------------------------------------------"

## Get the VPC ID:
VPC_ID=$(ibmcloud is vpcs | grep ${VPC_NAME} | awk '{print $1}')
echo " VPC_ID: ${VPC_ID}"

## Get a list of all the zones in your target region:
ZONES=()
for zone in $(ibmcloud is zones --quiet | grep ${REGION} | awk '{print $1}');
do
  ZONES+=(${zone});
done
echo " ZONES: ${ZONES[@]}"


## Get a list of all the subnets in your VPC region:
SUBNET_IDS=()
for zone in "${ZONES[@]}"; do
  SUBNET_IDS+=(
    $(ibmcloud is subnets | grep ${VPC_NAME}-subnet-${zone} | awk '{print $1}')
  );
done
echo " SUBNET_IDS: ${SUBNET_IDS[@]}"


echo "----------------------------------------------------------------------"
echo " 3. Create VPN Gateway "
echo "----------------------------------------------------------------------"
## 3. For each subnet in the VPC, create a VPN gateway and store the IDs:
VPN_GW_IDS=()
for i in {0..2}; do
  # ibmcloud is vpn-gateway-create ${VPC_NAME}-vpn-gw-${ZONES[${i}]} ${SUBNET_IDS[${i}]}
  VPN_GW_IDS+=(  $( ibmcloud is vpn-gateways | grep ${VPC_NAME}-vpn-gw-${ZONES[${i}]} |  awk '{print $1}') );
done
echo " VPN_GW_IDS: ${VPN_GW_IDS[@]}"


# Wait for the gateways to be available before proceeding:
echo " Sleeping for 120 secs "
sleep 120

echo "----------------------------------------------------------------------"
echo " 4. Retrieve VPC_SUBNET_CIDRS "
echo "----------------------------------------------------------------------"
## 4. Store the VPC subnet CIDRs in a variable for later use:
VPC_SUBNET_CIDRS=()
for i in {0..2}; do
  VPC_SUBNET_CIDRS+=(
    $(
      ibmcloud is subnets | grep ${VPC_NAME}-subnet-${ZONES[${i}]} | \
      awk '{print $4}'
    )
  );
done
echo " VPC_SUBNET_CIDRS: ${VPC_SUBNET_CIDRS[@]}"


echo "----------------------------------------------------------------------"
echo " 5. Create VPN Gateway Connection"
echo "----------------------------------------------------------------------"
## 5. For each VPN gateway, create a connection between its VPC subnet and the strongSwan peer:
for i in {0..2}; do
  ibmcloud is vpn-gateway-connection-create \
    ${VPC_NAME}-vpn-gw-conn-${ZONES[${i}]} ${VPN_GW_IDS[${i}]} \
    ${VPN_PEER_IP} ${VPN_PRESHARED_KEY} \
    --local-cidr ${VPC_SUBNET_CIDRS[${i}]} --local-cidr 166.8.0.0/14 \
    --peer-cidr ${VPN_PEER_CIDR};
done

# Wait for the gateways to be available before proceeding:
echo " Sleeping for 120 secs "
sleep 120

echo "----------------------------------------------------------------------"
echo " 6. Retrieve VPN_GW_IPS "
echo "----------------------------------------------------------------------"
## 6. Store the VPN gateway public IPs for peer VPN configuration:
VPN_GW_IPS=()
for i in {0..2}; do
  VPN_GW_IPS+=(
    $(
      ibmcloud is vpn-gateways | grep ${VPC_NAME}-vpn-gw-${ZONES[${i}]} | \
      awk '{print $6}'
    )
  );
done
echo " VPN_GW_IPS: ${VPN_GW_IPS[@]}"

echo "----------------------------------------------------------------------"
echo " 7. Print the values (VPC_SUBNET_CIDRS and VPN_GW_IPS) in config file (02-config-gateway.sh)"
echo "----------------------------------------------------------------------"

echo "#!/bin/bash" > 02-config-gateway.sh
echo "### This file is generated through script"  >> 02-config-gateway.sh

echo " VPC_SUBNET_CIDRS=( ${VPC_SUBNET_CIDRS[@]} )"  >> 02-config-gateway.sh
echo " VPN_GW_IPS=( ${VPN_GW_IPS[@]} )"  >> 02-config-gateway.sh


echo "Process Completed ...."

