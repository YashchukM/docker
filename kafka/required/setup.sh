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
ln -sf /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION} /opt/kafka

# Configure Kafka
rm -rf /opt/kafka/config/*
chmod +x /tmp/entrypoint.sh
mv /tmp/config/* /opt/kafka/config
mv /tmp/entrypoint.sh /opt/kafka

# Configure Kafka folders
mkdir -p /data/kafka
mkdir -p /logs/kafka

# Clean
rm -f "${KAFKA_ARTIFACT_PATH}"
rm -rf /tmp/*

yum remove -y -q wget zip unzip
yum clean all
