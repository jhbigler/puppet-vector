FROM ubuntu:20.04

RUN apt update -y && apt-get -y install curl wget

RUN curl -1sLf 'https://repositories.timber.io/public/vector/cfg/setup/bash.deb.sh' | bash

RUN wget https://apt.puppet.com/puppet7-release-focal.deb && \
    dpkg -i puppet7-release-focal.deb
RUN apt-get update && apt-get install -y puppet-agent
RUN /opt/puppetlabs/bin/puppet module install puppetlabs-stdlib --version 8.1.0
COPY test_manifest.sh /usr/local/sbin
RUN chmod +x /usr/local/sbin/test_manifest.sh
