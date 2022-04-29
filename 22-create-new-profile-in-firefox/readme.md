# Creating new profile in Firefox

This document explains about how to create new profile in Firefox to access VPC via Virtual Server.

## Steps

This is a one time process. Once it is done you don't need to repeat everytime you access.

1. In a Firefox browser, new tab, enter `about:profiles` in the address bar

<img src="images/image-00001.png">

The About Profile page opens.

2. Click `Create a New Profile`

<img src="images/image-00002.png">

3. Click `Continue`

<img src="images/image-00003.png">

4. Enter `New Profile Name`. ex: `waiops`

5. Click `Done`

<img src="images/image-00004.png">

Profile might have been created and available in the bottom of the page.

6. Click `Launch profile in new browser`

<img src="images/image-00005.png">

It opens new browser window. 

7. Click on `Settings`

<img src="images/image-00006.png">

8. In the opened page, goto the `Network Settings`

9. Click on `Settings`

<img src="images/image-00007.png">

10. Enter the following 

- SOCKS Host : localhost
- Port : 4444
- Choose Option : SOCKS v5

11. Click on `OK`

<img src="images/image-00008.png">

## References

This document is based on https://pages.github.ibm.com/hdm-swat/guides/vpn-secured-cluster/
