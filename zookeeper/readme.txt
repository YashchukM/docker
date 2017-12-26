- Build:
docker build https://github.com/YashchukM/docker.git#master:zookeeper -t zookeeper:3.4.11

- Tag to push:
docker tag zookeeper:3.4.11 myashchuk/zookeeper:3.4.11

- Run:
ZK_CLUSTER="host:port,host:port" && ZK_LOCAL_HOST="local.host.ip" && \
docker run \
    --user "$UID" \
    --env ZK_CLUSTER="$ZK_CLUSTER" \
    --env ZK_LOCAL_HOST="$ZK_LOCAL_HOST" \
    --volume /data/zookeeper:/data/zookeeper \
    --volume /logs/zookeeper:/logs/zookeeper \
    --publish 2181:2181 \
    --publish 2888:2888 \
    --publish 3888:3888 \
    --detach --interactive --tty \
    --restart always \
    --name zookeeper \
    myashchuk/zookeeper:3.4.11
