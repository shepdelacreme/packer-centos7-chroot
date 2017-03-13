#!/bin/sh -x

# Generate generic /etc/hosts file
cat > /etc/hosts << EOT
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

EOT

# network sysconfig
cat > /etc/sysconfig/network << EOT
NETWORKING=yes
NOZEROCONF=yes
EOT

# set default NIC config for eth0 device
cat > /etc/sysconfig/network-scripts/ifcfg-eth0 << EOF
DEVICE="eth0"
BOOTPROTO="dhcp"
ONBOOT="yes"
TYPE="Ethernet"
USERCTL="yes"
PEERDNS="yes"
IPV6INIT="no"
PERSISTENT_DHCLIENT="1"
EOF

# dhcp client config
cat  >> /etc/dhcp/dhclient.conf << EOF

timeout 300;
retry 60;
EOF

# clean up any network info for cloning
sed -i -e '/^HWADDR/d' -e '/^UUID/d' /etc/sysconfig/network-scripts/ifcfg-*

# Remove 70 udev rules per CentOS AMI build script
if [ -f "/etc/udev/rules.d/70-persistent-net.rules" ]; then
    rm /etc/udev/rules.d/70-persistent-net.rules
fi

# Retain eth0 in AWS
ln -fs /dev/null /etc/udev/rules.d/80-net-name-slot.rules

# rename biosdevname files
i=0
for _nic in $(find /etc/sysconfig/network-scripts/ifcfg-* ! -name ifcfg-lo); do
    mv $_nic /etc/sysconfig/network-scripts/ifcfg-eth${i}
    sed -i -e "s/^DEVICE=.*/DEVICE=eth${i}/" -e "s/^NAME=.*/NAME=eth${i}/" /etc/sysconfig/network-scripts/ifcfg-eth${i}
    i=$(expr $i + 1)
done
