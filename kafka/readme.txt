- Build:
docker build https://github.com/YashchukM/docker.git#master:kafka -t kafka:1.0.0

- Tag to push:
docker tag kafka:1.0.0 myashchuk/kafka:1.0.0

- Push:
docker push myashchuk/kafka:1.0.0

- Run:
docker run \
    --env ZK_CLUSTER="host:port,host:port" \
    --env KAFKA_ID="1" \
    --env KAFKA_ADVERTISED_LISTENERS="PLAINTEXT://local.host.ip:9092" \
    --env KAFKA_RUN_UID="$UID" \
    --env KAFKA_RUN_GID="$(id $(whoami) -g)" \
    --env KAFKA_HEAP_OPTS="-Xms256M -Xmx256M" \
    --volume /data/kafka:/data/kafka \
    --volume /logs/kafka:/logs/kafka \
    --publish 9092:9092 \
    --detach --interactive --tty \
    --restart always \
    --name kafka \
    myashchuk/kafka:1.0.0
