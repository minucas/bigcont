#
# Logstash Dockerfile
#
# https://github.com/bigcontainer/bigcont
#

# Pull base image
FROM localhost:5000/centos
#FROM centos:7

# Build-time vars
ARG LS_VERSION=2.3.4
ARG LS_MIRROR=https://packages.elastic.co/logstash/2.3/centos

# Custom metadata
LABEL name="logstash" logstash-version=$LS_VERSION

# Define commonly used JAVA_HOME variable
ENV JAVA_VERSION 1.8.0 
ENV JAVA_HOME /usr/lib/jvm/jre

# Java installation
RUN \
  yum install -y java-${JAVA_VERSION}-openjdk wget && \
  yum clean all

# Logstash installation
ADD files/logstash.repo /etc/yum.repos.d/logstash.repo
RUN \
  rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch && \
  yum install -y logstash && \
  yum clean all 

EXPOSE 2181 2888 3888    
  
#ENTRYPOINT ["/opt/zookeeper/bin/zkServer.sh"]
#CMD ["start-foreground"] 
