#!/bin/bash
set -uex

# Install additional packages
yum -y -q install wget zip unzip

# Download archive
mkdir -p /opt
wget -nv "${ZK_URL}" -O "${ZK_ARTIFACT_PATH}"

# Install ZK
mkdir -p /opt/zookeeper-${ZK_VERSION}
tar -xzf "${ZK_ARTIFACT_PATH}" -C /opt/zookeeper-${ZK_VERSION} --strip-components=1
ln -sf /opt/zookeeper-${ZK_VERSION} /opt/zookeeper

# Configure ZK
rm -rf /opt/zookeeper/conf/*
chmod +x /tmp/entrypoint.sh
mv /tmp/conf/* /opt/zookeeper/conf
mv /tmp/entrypoint.sh /opt/zookeeper

# Configure ZK folders
mkdir -p /data/zookeeper
mkdir -p /logs/zookeeper

# Clean
rm -f "${ZK_ARTIFACT_PATH}"
rm -rf /tmp/*

yum remove -y -q wget zip unzip
yum clean all
