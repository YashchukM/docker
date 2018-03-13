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
check_env ZK_RUN_UID
check_env ZK_CLUSTER
check_env ZK_LOCAL_HOST

# UID/GID magic to start container with internal uid\gid same as external.
# By internal I mean uid\gid in docker container.
# By external I mean uid\gid of user, starting this container.
# That helps to run container not as a superuser (in the end), while still being 
# able to write logs into appropriate folders with ownership of external user.
ZK_RUN_GID=${ZK_RUN_GID:-$ZK_RUN_UID}
check_gid zookeeper $ZK_RUN_GID
check_uid zookeeper $ZK_RUN_UID $ZK_RUN_GID

# Utility folders
chown -RL $ZK_RUN_UID:$ZK_RUN_GID /opt/zookeeper
chown -R $ZK_RUN_UID:$ZK_RUN_GID /data/zookeeper
chown -R $ZK_RUN_UID:$ZK_RUN_GID /logs/zookeeper

# Configure zookeeper if not yet configured
if [ ! -f /opt/zookeeper/.configured ]; then
    touch /opt/zookeeper/.configured
    SERVER_ID=1
    
    # Split string into array: "a, b, c" -> ["a", "b", "c"]
    IFS=',' read -ra HOSTS <<< "${ZK_CLUSTER}"
    for SERVER in ${HOSTS[@]}
    do
        # Host without port: SERVER="123.123.123.123:1234", "${SERVER%%:*}" -> "123.123.123.123"
        if [ ${SERVER%%:*} == ${ZK_LOCAL_HOST} ]; then
            echo server.${SERVER_ID}=0.0.0.0:2888:3888 >> /opt/zookeeper/conf/zoo.cfg
            echo ${SERVER_ID} > /data/zookeeper/myid
        else
            echo server.${SERVER_ID}=${SERVER%%:*}:2888:3888 >> /opt/zookeeper/conf/zoo.cfg
        fi
        SERVER_ID=$((SERVER_ID + 1))
    done

    ZK_HEAP_OPTS=${ZK_HEAP_OPTS:-"-Xms512m -Xmx512m"}
    echo "export JAVA_OPTS=\"$ZK_HEAP_OPTS\"" >> /opt/zookeeper/conf/java.env
fi

# Run as a zookeeper inside container
runuser -u zookeeper /opt/zookeeper/bin/zkServer.sh start-foreground
