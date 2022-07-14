#!/usr/bin/env bash

source ./01-config-virtualserver.sh
source ./02-config-gateway.sh

echo "VPN_PEER_CIDR : $VPN_PEER_CIDR"
echo " VPC_SUBNET_CIDRS: ${VPC_SUBNET_CIDRS[@]}"

# sudo apt-get update
# sudo apt-get install -y strongswan

sudo bash -c "cat >> /etc/sysctl.conf" << EOF
net.ipv4.ip_forward = 1
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.all.send_redirects = 0
EOF

sleep 5

sudo sysctl -p

sleep 5

echo "${VPN_PEER_IP} ${VPN_GW_IPS[0]} : PSK \"${VPN_PRESHARED_KEY}\"" >> /etc/ipsec.secrets
echo "${VPN_PEER_IP} ${VPN_GW_IPS[1]} : PSK \"${VPN_PRESHARED_KEY}\"" >> /etc/ipsec.secrets
echo "${VPN_PEER_IP} ${VPN_GW_IPS[2]} : PSK \"${VPN_PRESHARED_KEY}\"" >> /etc/ipsec.secrets

sleep 5

sudo bash -c "cat > /etc/ipsec.vpn.conf" << EOF
config setup
    charondebug="ike 2,cfg 2, knl 1"
    uniqueids=yes
    strictcrlpolicy=no

conn %default
    auto=route
    esp=aes256-sha256!
    ike=aes128-sha1-modp1024!
    keyexchange=ikev2
    lifetime=10800s
    ikelifetime=36000s
    dpddelay=30s
    dpdaction=restart
    dpdtimeout=120s

conn vpc-subnet-1
    type=tunnel
    auto=route
    left=${VPN_PEER_IP}
    leftsubnet=${VPN_PEER_CIDR}
    leftauth=psk
    leftid="${VPN_PEER_IP}"
    dpdaction=restart
    rightsubnet=${VPC_SUBNET_CIDRS[0]},166.8.0.0/14,161.26.0.0/16
    right=${VPN_GW_IPS[0]}
    rightauth=psk
    rightid="${VPN_GW_IPS[0]}"

conn vpc-subnet-2
    also=vpc-subnet-1
    rightsubnet=${VPC_SUBNET_CIDRS[1]}
    right=${VPN_GW_IPS[1]}
    rightauth=psk
    rightid="${VPN_GW_IPS[1]}"

conn vpc-subnet-3
    also=vpc-subnet-2
    rightsubnet=${VPC_SUBNET_CIDRS[2]}
    right=${VPN_GW_IPS[2]}
    rightauth=psk
    rightid="${VPN_GW_IPS[2]}"
EOF

sleep 5

sudo bash -c "cat >> /etc/ipsec.conf" << EOF
include /etc/ipsec.vpn.conf
EOF

sleep 5

sudo systemctl restart ipsec
sleep 5
sudo systemctl status ipsec
sleep 5
sudo ipsec status
sleep 5
