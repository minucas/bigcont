#!/bin/bash

echo ${MYID} > /tmp/zookeeper/myid

sed -i "s/service-server$MYID/0.0.0.0/" /opt/zookeeper/conf/zoo.cfg

exec /opt/zookeeper/bin/zkServer.sh start-foreground
