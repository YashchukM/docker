- Build:
docker build https://github.com/YashchukM/docker.git#master:zookeeper -t zookeeper:3.4.11

- Tag to push:
docker tag zookeeper:3.4.11 myashchuk/zookeeper:3.4.11

- Push:
docker push myashchuk/zookeeper:3.4.11

- Run:
docker run \
    --env ZK_CLUSTER="host:port,host:port" \
    --env ZK_LOCAL_HOST="local.host.ip" \
    --env ZK_RUN_UID="$UID" \
    --env ZK_RUN_GID="$(id $(whoami) -g)" \     # Optional
    --env ZK_HEAP_OPTS="-Xms512m -Xmx512m" \    # Optional
    --volume /data/zookeeper:/data/zookeeper \
    --volume /logs/zookeeper:/logs/zookeeper \
    --publish 2181:2181 \
    --publish 2888:2888 \
    --publish 3888:3888 \
    --detach --interactive --tty \
    --restart always \
    --name zookeeper \
    myashchuk/zookeeper:3.4.11
