#!/bin/bash

##### ----------------   General  --------------------------------

## IBM Cloud API key - for EY ACCOUNT
IBMCLOUD_API_KEY=aaaaa


##### ----------------   VPC - Cluster  --------------------------------
## Resource Group
RESOURCE_GROUP=aiops-poc-ocp

## REGION
REGION=us-south

## VPC
VPC_NAME=aiops-poc-vpc

## OCP
OCP_VERSION=4.8.35_openshift
WORKER_FLAVOR=bx2.16x64
WORKERS_PER_ZONE=2

##### ----------------   Virtual Server Instance in Classic Infra (JUMP_BOX)  --------------------------------

JUMP_BOX_REGION=us-east
JUMP_BOX_RESOURCE_GROUP=$RESOURCE_GROUP
JUMP_BOX_ZONE=wdc04

JUMP_BOX_NAME=aiops-poc-jumpbox
JUMP_BOX_DOMAIN=aiops.com
JUMP_BOX_CPU=8
JUMP_BOX_MEMORY=16384
JUMP_BOX_OS=Ubuntu_LATEST

JUMP_BOX_SECURITY_GROUP=aiops-poc-jumpbox-sg

## USER Laptop IP 1 
JUMP_BOX_REMOTE_IP1=1.2.3.4

## USER Laptop IP 2
JUMP_BOX_REMOTE_IP2=1.1.1.1

## USER Laptop ssh-key
JUMP_BOX_SSH_KEY1=gandhi-key
JUMP_BOX_SSH_KEY2=vbr-key
