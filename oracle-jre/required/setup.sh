#!/bin/bash
set -uex

# Updating packages
yum -y -q update

# Installing additional packages
yum -y -q install wget zip unzip

# Downloading JRE
wget -nv --no-cookies --no-check-certificate \
  --header "Cookie: oraclelicense=accept-securebackup-cookie" \
  "${JRE_URL}" -O ${JRE_ARTIFACT_PATH}

# Installing JRE
mkdir -p "${JAVA_HOME}"
tar -xzvf "${JRE_ARTIFACT_PATH}" -C "${JAVA_HOME}" --strip-components=1
alternatives --install /usr/bin/java java "${JAVA_HOME}"/bin/java 1

# Clean
rm -f "${JRE_ARTIFACT_PATH}"
rm -rf /tmp/*

yum remove -y wget zip unzip
yum clean all
