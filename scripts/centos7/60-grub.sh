#!/bin/sh -x
#
# grub stuff

# Source the vars we need to know the device name
source /tmp/env_vars

# Force install of various Xen/AWS specific drivers into the kernel
dracut --force --add-drivers "xen_blkfront virtio ixgbevf" /boot/initramfs-$(uname -r).img

# Drop default config for grub
cat > /etc/default/grub << EOT
GRUB_TIMEOUT=1
GRUB_DISTRIBUTOR="$(sed 's, release .*$,,g' /etc/system-release)"
GRUB_DEFAULT=saved
GRUB_DISABLE_SUBMENU=true
GRUB_TERMINAL="serial console"
GRUB_SERIAL_COMMAND="serial --speed=115200"
GRUB_CMDLINE_LINUX="console=ttyS0,115200 console=tty0 vconsole.font=latarcyrheb-sun16 crashkernel=auto vconsole.keymap=us plymouth.enable=0 net.ifnames=0 biosdevname=0"
GRUB_DISABLE_RECOVERY="true"
EOT

# Generate grub config
grub2-mkconfig -o /boot/grub2/grub.cfg

# Install Grub into the attached device
grub2-install $DEVICE
