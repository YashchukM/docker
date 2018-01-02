#!/bin/bash
set -uex

# Install additional packages
yum -y -q install wget zip unzip

# Download archive
mkdir -p /opt
wget -nv "${KAFKA_URL}" -O "${KAFKA_ARTIFACT_PATH}"

# Install Kafka
mkdir -p /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION}
tar -xzf "${KAFKA_ARTIFACT_PATH}" -C /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION} --strip-components=1
ln -sf /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION} "${KAFKA_HOME}"

# Configure Kafka


# Configure Kafka folders
mkdir -p /data/kafka
mkdir -p /logs/kafka

# Clean
rm -f "${KAFKA_ARTIFACT_PATH}"
rm -rf /tmp/*

yum remove -y -q wget zip unzip
yum clean all

wget -nv "${KAFKA_URL}" /tmp/kafka_2.11-1.0.0.tgz
tar -xzf /tmp/kafka_2.11-1.0.0.tgz -C /opt/kafka_2.11-1.0.0 --strip-components=1