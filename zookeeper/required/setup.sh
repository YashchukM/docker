#!/bin/bash

set -uex

# Install additional packages
yum -y -q install wget zip unzip

# Download archive
mkdir -p "/opt"
wget -nv "${ZK_URL}" -O "${ZK_ARTIFACT_PATH}"

# Install ZK
mkdir -p "/opt/zookeeper-${ZK_VERSION}"
tar -xzf "${ZK_ARTIFACT_PATH}" -C "/opt/zookeeper-${ZK_VERSION}" --strip-components=1
ln -sf "/opt/zookeeper-${ZK_VERSION}" "${ZK_HOME}"

# Configure ZK
rm -rf "${ZK_HOME}/conf/*"
chmod +x "/tmp/entrypoint.sh"
mv "/tmp/conf/*" "${ZK_HOME}/conf"
mv "/tmp/entrypoint.sh" "${ZK_HOME}"

# Configure ownership
mkdir -p "/data/zookeeper"
mkdir -p "/logs/zookeeper"
useradd -U zookeeper -d "${ZK_HOME}"
chown -RL zookeeper:zookeeper "${ZK_HOME}"
chown -R zookeeper:zookeeper "/data/zookeeper"
chown -R zookeeper:zookeeper "/logs/zookeeper"

# Clean
rm -f "${ZK_ARTIFACT_PATH}"
rm -rf "/tmp/*"

yum remove -y wget zip unzip
yum clean all
