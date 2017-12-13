#!/bin/bash

set -uex

echo "Updating packages ..."
yum -yq update

echo "Installing additional packages ..."
yum -yq install wget zip unzip

echo "Downloading JRE ..."
wget -nv --no-cookies --no-check-certificate \
  --header "Cookie: oraclelicense=accept-securebackup-cookie" \
  "${JRE_URL}" -O ${JRE_ARTIFACT_PATH}

echo "Installing JRE ..."
mkdir -p "${JAVA_HOME}"
tar -xzvf "${JRE_ARTIFACT_PATH}" -C "${JAVA_HOME}" --strip-components=1
ln -sf /usr/bin/java ${JAVA_HOME}/bin/java
ln -sf /usr/bin/jar ${JAVA_HOME}/bin/jar

# Clean
rm -f "${JRE_ARTIFACT_PATH}"
rm -rf /tmp/*

yum remove -y wget zip unzip
yum clean all

echo "JRE setup done."
