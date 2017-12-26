FROM myashchuk/oracle-jre:1.8

ARG ZK_VERSION=3.4.11
ARG ZK_URL="http://apache.mirrors.pair.com/zookeeper/zookeeper-${ZK_VERSION}/zookeeper-${ZK_VERSION}.tar.gz"
ARG ZK_ARTIFACT_PATH=/tmp/zookeeper-${ZK_VERSION}.tar.gz
ARG ZK_HOME=/opt/zookeeper

COPY ["required", "/tmp"]

RUN chmod +x /tmp/setup.sh && /tmp/setup.sh

EXPOSE 2181 2888 3888
VOLUME ["/data/zookeeper", "/logs/zookeeper"]
ENV ZK_HOME="${ZK_HOME}"
ENTRYPOINT ["/opt/zookeeper/entrypoint.sh"]
