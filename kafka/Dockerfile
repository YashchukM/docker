FROM myashchuk/zookeeper:3.4.11

ARG SCALA_VERSION=2.11
ARG KAFKA_VERSION=1.0.0
ARG KAFKA_URL="http://www-eu.apache.org/dist/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz"
ARG KAFKA_ARTIFACT_PATH=/tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz
ARG KAFKA_HOME=/opt/kafka

COPY ["required", "/tmp"]

RUN chmod +x /tmp/setup.sh && /tmp/setup.sh

EXPOSE 9092
VOLUME ["/data/kafka", "/logs/kafka"]
ENV KAFKA_HOME="${KAFKA_HOME}"
ENTRYPOINT ["/opt/kafka/entrypoint.sh"]
