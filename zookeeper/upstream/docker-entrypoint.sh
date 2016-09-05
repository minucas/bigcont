#!/bin/bash

# Persists the ID of the current instance of Zookeeper
echo ${MYID} > /tmp/zookeeper/myid

# http://stackoverflow.com/questions/30940981/zookeeper-error-cannot-open-channel-to-x-at-election-address
sed -i "s/service-server$MYID/0.0.0.0/" /opt/zookeeper/conf/zoo.cfg

exec /opt/zookeeper/bin/zkServer.sh start-foreground
