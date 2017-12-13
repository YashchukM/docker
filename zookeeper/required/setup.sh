#!/bin/bash

set -uex

# Install additional packages
yum -y -q install wget zip unzip

# Download archive
wget -nv "${ZK_URL}" -O "${ZK_ARTIFACT_PATH}"

# Install ZK
mkdir -p "${ZK_HOME}"
tar -xzvf "${ZK_ARTIFACT_PATH}" -C /opt --strip-components=1
alternatives --install /usr/bin/java java ${JAVA_HOME}/bin/java 1

# Clean
