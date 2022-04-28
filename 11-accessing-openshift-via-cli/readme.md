# Accessing OpenShift via CLI

This document explains about how to access OpenShift installed in VPC via CLI.

- Accessing OpenShift via CLI from Virtual Server

This document is based on https://pages.github.ibm.com/hdm-swat/guides/vpn-secured-cluster/

## PreRequisite

The following are required as a prereq for proceeding with this document.

1.  Proxy Virtual Server `IP Address` and `Password` (where strongSwan is installed)
    Ex: `1.2.3.4`

2. Virtual Server should be enabled to allow your IP as inbound. Check with Admin.

3.  `oc login ...` command should have been copied via `Copy Login Command` from OpenShift Console.


## Steps

1. Substitute the <virtual-server-ip> in the below command 

2. Run the command in a command shell to ssh into the virtual server. Use `Password` if needed.

```
ssh root@<virtual-server-ip>
```

2. Run the `oc login .....` command copied from the OpenShift Console.

You should have logged into OCP vial CLI from the Virtual Server.