# Create ssh proxy to the strongSwan in Virtual Server

This document explains about how to Create ssh proxy to the strongSwan in Virtual Server

## Steps 

1. Replace < virtual-server-ip > in the below command and run the same in a command shell.

```
ssh -N -D 4444 root@<virtual-server-ip>
```

2. Leave this session open

## References

This document is based on https://pages.github.ibm.com/hdm-swat/guides/vpn-secured-cluster/
