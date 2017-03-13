#!/bin/sh -x
#
# Enable necessary services
systemctl -q enable rsyslog
systemctl -q enable sshd
systemctl -q enable cloud-init
systemctl -q enable cloud-config
systemctl -q enable cloud-final
systemctl -q enable cloud-init-local
systemctl -q enable tuned
systemctl -q enable auditd
systemctl -q enable chronyd
systemctl -q enable rsyslog
systemctl -q enable network

systemctl -q disable kdump

systemctl mask tmp.mount
