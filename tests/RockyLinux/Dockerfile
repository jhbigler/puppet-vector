FROM rockylinux/rockylinux:8

ENV container docker
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

RUN curl -1sLf 'https://repositories.timber.io/public/vector/cfg/setup/bash.rpm.sh' | bash
RUN rpm -i https://yum.puppet.com/puppet7-release-el-8.noarch.rpm
RUN dnf install -y puppet-agent procps
RUN /opt/puppetlabs/bin/puppet module install puppetlabs-stdlib --version 8.1.0
COPY test_manifest.sh /usr/local/sbin
RUN chmod +x /usr/local/sbin/test_manifest.sh

VOLUME ["/sys/fs/cgroup"]

CMD ["/sbin/init"]