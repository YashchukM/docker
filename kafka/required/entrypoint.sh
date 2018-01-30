#!/bin/bash
set -uex

if [ -z ${KAFKA_RUN_UID} ]; then echo "Error. Need to set KAFKA_RUN_UID environment variable"; exit 1; fi
if [ -z ${ZK_CLUSTER} ]; then echo "Error. Need to set ZK_CLUSTER environment variable"; exit 1; fi
if [ -z ${KAFKA_ID} ]; then echo "Error. Need to set KAFKA_ID environment variable"; exit 1; fi

# TODO: Potentially can be run with different uids
KAFKA_RUN_GID=${KAFKA_RUN_GID:-$KAFKA_RUN_UID}
groupadd --gid $KAFKA_RUN_GID kafka

useradd --uid $KAFKA_RUN_UID --gid $KAFKA_RUN_GID kafka
chown -RL $KAFKA_RUN_UID:$KAFKA_RUN_GID /opt/kafka
chown -R $KAFKA_RUN_UID:$KAFKA_RUN_GID /data/kafka
chown -R $KAFKA_RUN_UID:$KAFKA_RUN_GID /logs/kafka

if [ ! -f /opt/kafka/.configured ]; then
    touch /opt/kafka/.configured
    echo "broker.id=${KAFKA_ID}" >> /opt/kafka/config/server.properties
    echo "zookeeper.connect=${ZK_CLUSTER}" >> /opt/kafka/config/server.properties

    if [ ! -z ${KAFKA_ADVERTISED_LISTENERS} ]; then
        echo "advertised.listeners=${KAFKA_ADVERTISED_LISTENERS}" >> /opt/kafka/config/server.properties
    fi
fi

runuser -u kafka /opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties