#
# Apache Zookeeper Dockerfile
#
# https://github.com/bigcontainer/bigcont
#

# Pull base image
FROM centos:7

# build-time 
ARG ZK_VERSION=zookeeper-3.48
ARG ZK_MIRROR=http://www-eu.apache.org/dist/zookeeper/stable/

# custom metadata
LABEL name="zookeeper" version=$ZK_VERSION

# Define commonly used JAVA_HOME variable
ENV JAVA_VERSION 1.8.0 
ENV JAVA_HOME /usr/lib/jvm/java-${JAVA_VERSION}

# Java installation
RUN \
  yum update -y && \
  yum install -y java-${JAVA_VERSION}-openjdk wget && \
  yum clean all

ENV JAVA_HOME /usr/lib/jvm/java-${JAVA_VERSION}

# Zookeeper download
RUN \
  wget -q ${ZK_MIRROR}/stable/$ZK_VERSION.tar.gz && \ 
  wget -q https://www.apache.org/dist/zookeeper/KEYS && \ 
  wget -q https://www.apache.org/dist/zookeeper/${ZK_VERSION}/${ZK_VERSION}.tar.gz.asc && \
  wget -q https://www.apache.org/dist/zookeeper/${ZK_VERSION}/{ZK_VERSION}.tar.gz.md5 

# Verify download
RUN \
  md5sum -c ${ZK_VERSION}.tar.gz.md5 && \
  gpg --import KEYS && \
  gpg --verify ${ZK_VERSION}.tar.gz.asc 

# Install 
RUN \
  tar -xzf zookeeper-${ZOOKEEPER_VERSION}.tar.gz -C /opt 

# Configure
RUN \
  cp /opt/zookeeper/conf/zoo_sample.cfg /opt/zookeeper/conf/zoo.cfg && \
  mkdir -p /tmp/zookeeper

EXPOSE 2181 2888 3888    
  
ENTRYPOINT ["/opt/zookeeper/bin/zkServer.sh"]
CMD ["start-foreground"] 

