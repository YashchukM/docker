#!/bin/bash
set -uex

if [ -z ${ZK_RUN_UID} ]; then echo "Error. Need to set ZK_RUN_UID environment variable"; exit 1; fi
if [ -z ${ZK_CLUSTER} ]; then echo "Error. Need to set ZK_CLUSTER environment variable"; exit 1; fi
if [ -z ${ZK_LOCAL_HOST} ]; then echo "Error. Need to set ZK_LOCAL_HOST environment variable"; exit 1; fi

ZK_RUN_GID=${ZK_RUN_GID:-$ZK_RUN_UID}
groupadd --gid $ZK_RUN_GID zookeeper

useradd --uid $ZK_RUN_UID --gid $ZK_RUN_GID zookeeper
chown -RL $ZK_RUN_UID:$ZK_RUN_GID /opt/zookeeper
chown -R $ZK_RUN_UID:$ZK_RUN_GID /data/zookeeper
chown -R $ZK_RUN_UID:$ZK_RUN_GID /logs/zookeeper

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
fi

runuser -u zookeeper /opt/zookeeper/bin/zkServer.sh start-foreground
