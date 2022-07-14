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
echo " 2. Create RESOURCE_GROUP "
echo "----------------------------------------------------------------------"
### Create resource group
ibmcloud resource group-create $RESOURCE_GROUP
### Get resource group id
RESOURCE_GROUP_ID=$(ibmcloud resource groups | grep ${RESOURCE_GROUP} | awk '{print $2}')
### Set the target to the created resource group
ibmcloud target -g $RESOURCE_GROUP_ID


echo "----------------------------------------------------------------------"
echo " 3. Create VPC "
echo "----------------------------------------------------------------------"
## 4. Create the VPC:
ibmcloud is vpc-create ${VPC_NAME}

## 5. Save the VPC ID:
VPC_ID=$(ibmcloud is vpcs | grep ${VPC_NAME} | awk '{print $1}')


echo "----------------------------------------------------------------------"
echo " 4. Create PUBLIC GATEWAYs "
echo "----------------------------------------------------------------------"
echo "6. Create 3 public gateways (1 for each zone):"

## Get a list of all the zones in your target region:
ZONES=()
for zone in $(ibmcloud is zones --quiet | grep ${REGION} | awk '{print $1}');
do
  ZONES+=(${zone});
done


## Create a public gateway for each zone:
for zone in "${ZONES[@]}"; do
  ibmcloud is public-gateway-create ${VPC_NAME}-pg-${zone} ${VPC_ID} ${zone};
done

## Save the public gateway IDs:
PG_IDS=()
for zone in "${ZONES[@]}"; do
  PG_IDS+=(
    $(
      ibmcloud is public-gateways | grep ${VPC_NAME}-pg-${zone} | \
      awk '{print $1}'
    )
  );
done

echo "----------------------------------------------------------------------"
echo " 5. Create SUBNET and attach PUBLIC GATEWAY"
echo "----------------------------------------------------------------------"
echo " Create 3 subnets (1 for each zone) and attach a public gateway to each "

## 7. Create 3 subnets (1 for each zone) and attach a public gateway to each:
for i in "${!ZONES[@]}"; do
  ibmcloud is subnet-create ${VPC_NAME}-subnet-${ZONES[$i]} ${VPC_ID}  \
    --zone ${ZONES[$i]} --ipv4-address-count 256 --public-gateway-id ${PG_IDS[$i]};
done


## 8. Save the subnet IDs:
SUBNET_IDS=()
for zone in "${ZONES[@]}"; do
  SUBNET_IDS+=(
    $(ibmcloud is subnets | grep ${VPC_NAME}-subnet-${zone} | awk '{print $1}')
  );
done

echo "----------------------------------------------------------------------"
echo " 6. Create an IBM Cloud Object Storage instance "
echo "----------------------------------------------------------------------"

## 9. Create an IBM Cloud Object Storage instance to backup the internal registry:
ibmcloud resource service-instance-create ${VPC_NAME}-cos cloud-object-storage standard global


## 10. Save the COS CRN (it's ID):
COS_CRN=$(
  ibmcloud resource service-instance ${VPC_NAME}-cos | grep ID: | awk 'NR==1{print $2}'
)


echo "----------------------------------------------------------------------"
echo " 7. Create OCP Cluster"
echo "----------------------------------------------------------------------"
## 11. Create the cluster:
ibmcloud oc cluster create vpc-gen2 --name ${VPC_NAME}-ocp-cluster \
  --zone ${ZONES[0]} --version ${OCP_VERSION} --flavor ${WORKER_FLAVOR} \
  --workers ${WORKERS_PER_ZONE} --vpc-id ${VPC_ID} \
  --subnet-id ${SUBNET_IDS[0]} --cos-instance ${COS_CRN} \
  --disable-public-service-endpoint --entitlement cloud_pak


## 12. Wait for the cluster to complete building
ibmcloud oc cluster get --cluster ${VPC_NAME}-ocp-cluster