#!/bin/bash

# Persists the ID of the current instance of Zookeeper
echo ${MYID} > /tmp/zookeeper/myid

exec /opt/zookeeper/bin/zkServer.sh start-foreground
