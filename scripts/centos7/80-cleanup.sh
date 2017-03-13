#!/bin/sh -x

#Remove temp files
rm -f /tmp/env_vars

# Clean YUM
yum history new
yum -y clean all
truncate -c -s 0 /var/log/yum.log

# Lock the root user
passwd -d root
passwd -l root

# Shred SSH key files
shred -uf /etc/ssh/*_key
shred -uf /etc/ssh/*_key.pub

# Shred history files
find /root /home -name '.bash_history' -exec shred -uf {} \;

# Remove random-seed so its not the same across images
rm -f /var/lib/random-seed

# Remove ssh keys from user home dirs
find /root /home -name 'authorized_keys' -exec truncate -s 0 {} \;

# Fix SELinux contexts (bootstrapping in chroot requires a full relabel for some reason)
/sbin/setfiles -F -e /proc -e /sys -e /dev /etc/selinux/targeted/contexts/files/file_contexts /

# Pause so setfiles can finish before moving on to next action
sleep 30s

# Disk clean up final
dd if=/dev/zero of=/zeros bs=1M
rm -f /zeros
sync
