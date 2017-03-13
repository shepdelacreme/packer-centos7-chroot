#!/bin/sh -x
#

# Source variables for fstab generation
source /tmp/env_vars

# locale
echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen
echo 'LANG=en_US.UTF-8' > /etc/locale.conf

# authconfig stuff
authconfig --enableshadow --passalgo=sha512 --updateall

# Create basic homedir for root user
cp -a /etc/skel/.bash* /root

# Timezone
cp /usr/share/zoneinfo/UTC /etc/localtime
echo 'ZONE="UTC"' > /etc/sysconfig/clock

# Set tuned profile to virtual-guest for use in AWS/virt
echo "virtual-guest" > /etc/tuned/active_profile

# Disallow root login via SSHD
sed -i -r 's@^#?PermitRootLogin.*$@PermitRootLogin no@' /etc/ssh/sshd_config

# Remove requiretty setting in sudoers if it exists
sed -i -r "s@^.*requiretty@#Defaults !requiretty@" /etc/sudoers

# disable firstboot
echo "RUN_FIRSTBOOT=NO" > /etc/sysconfig/firstboot

# instance type markers - Pulled from CentOS AMI creation kickstart
echo 'genclo' > /etc/yum/vars/infra

# setup systemd to boot to the right runlevel
rm -f /etc/systemd/system/default.target
ln -s /lib/systemd/system/multi-user.target /etc/systemd/system/default.target

# disable AutoVT services for TTYs
sed -i -r 's@^#NAutoVTs=.*@NAutoVTs=0@' /etc/systemd/logind.conf

# Generate basic fstab
cat > /etc/fstab << EOT
#
# /etc/fstab
#
# Accessible filesystems, by reference, are maintained under '/dev/disk'
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
#
LABEL=root /         xfs     defaults,noatime   1 1
tmpfs      /dev/shm  tmpfs   defaults           0 0
devpts     /dev/pts  devpts  gid=5,mode=620     0 0
sysfs      /sys      sysfs   defaults           0 0
proc       /proc     proc    defaults           0 0
EOT
