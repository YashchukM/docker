#!/bin/bash
set -uex

# Additional functions
function check_env {
    env_name=$1
    if [ -z ${!env_name} ]; then 
        echo "Error. Need to set $env_name environment variable"
        exit 1
    fi
}

function check_gid {
    name=$1; gid=$2
    if id -g $name > /dev/null 2>&1; then
        echo "Group $name already exists, gid: $gid"
    else
        groupadd --gid $gid $name
    fi
}

function check_uid {
    name=$1; uid=$2; gid=$3
    if id -u $name > /dev/null 2>&1; then
        echo "User $name already exists, uid: $uid"
    else
        useradd --uid $uid --gid $gid $name
    fi
}

# Input checks
check_env KAFKA_RUN_UID
check_env ZK_CLUSTER
check_env KAFKA_ID

# UID/GID magic to start container with internal uid\gid same as external.
# By internal I mean uid\gid in docker container.
# By external I mean uid\gid of user, starting this container.
# That helps to run container not as a superuser (in the end), while still being 
# able to write logs into appropriate folders with ownership of external user.
KAFKA_RUN_GID=${KAFKA_RUN_GID:-$KAFKA_RUN_UID}
check_gid kafka $KAFKA_RUN_GID
check_uid kafka $KAFKA_RUN_UID $KAFKA_RUN_GID

# Utility folders
chown -RL $KAFKA_RUN_UID:$KAFKA_RUN_GID /opt/kafka
chown -R $KAFKA_RUN_UID:$KAFKA_RUN_GID /data/kafka
chown -R $KAFKA_RUN_UID:$KAFKA_RUN_GID /logs/kafka

# Configure kafka if not yet configured
if [ ! -f /opt/kafka/.configured ]; then
    touch /opt/kafka/.configured
    echo "broker.id=${KAFKA_ID}" >> /opt/kafka/config/server.properties
    echo "zookeeper.connect=${ZK_CLUSTER}" >> /opt/kafka/config/server.properties

    if [ ! -z ${KAFKA_ADVERTISED_LISTENERS} ]; then
        echo "advertised.listeners=${KAFKA_ADVERTISED_LISTENERS}" >> /opt/kafka/config/server.properties
    fi
fi

# Run as a kafka inside container
runuser -u kafka /opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties