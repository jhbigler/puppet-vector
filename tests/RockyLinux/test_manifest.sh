#!/bin/bash
manifest=$1

/opt/puppetlabs/bin/puppet apply /etc/puppetlabs/code/modules/vector/tests/RockyLinux/manifests/$1
sleep 2
systemctl status vector --no-pager
exit $?
