#!/bin/sh -x
#

# Install basic set of packages
yum -y install @core authconfig audit deltarpm sudo chrony cloud-init cloud-utils-growpart dracut-config-generic dracut-norescue firewalld grub2 kernel nfs-utils rsync tar yum-utils tuned dnsmasq gnutls gdisk

# Remove the packages we don't want or need in our AWS base image
yum -y remove hwdata linux-firmware dracut-config-rescue NetworkManager aic94xx-firmware alsa-firmware alsa-lib alsa-tools-firmware biosdevname iprutils ivtv-firmware iwl100-firmware iwl1000-firmware iwl105-firmware iwl135-firmware iwl2000-firmware iwl2030-firmware iwl3160-firmware iwl3945-firmware iwl4965-firmware iwl5000-firmware iwl5150-firmware iwl6000-firmware iwl6000g2a-firmware iwl6000g2b-firmware iwl6050-firmware iwl7260-firmware libertas-sd8686-firmware libertas-sd8787-firmware libertas-usb8388-firmware plymouth --setopt="clean_requirements_on_remove=1"
