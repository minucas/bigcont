## Quick Background: Apache Zookeeper

Zookeeper enables applications developers to focus mainly on their applications
logic rather than coordination tasks, ideally separates application data from
control or coordination data. It expose a simple API. inspired by the
filesystem API, that allows developers to implement common coordination tasks,
such as selecting a master server, managing group membership, and managing
metadata, configuration information.

### Why is important Zookeeper in a Big Data ecosystem?

Because is a foundation for many other tools like Apache Kafka, Apache Hadoop,
Apache HBase, and so on.

### Getting started with Zookeeper

wget http://www-eu.apache.org/dist/zookeeper/stable/zookeeper-3.4.8.tar.gz

Zookeeper servers run in two modes: *standalone* and *quorum*.

Zookeeper in standalone mode is for non real workloads (only one server) and 
Zookeeper in quorum mode is a group of Zookeeper servers, which we call
*Zookeeper esemble*, which replicate the state, and together they serve client
requests.

#### Simple session with Zookeeper in standalone mode:

``````
$ java -version
openjdk version "1.8.0_101"
$ tar xvzf zookeeper-3.4.8.tar.gz 
$ cd zookeeper-3.4.8/
$ cp conf/zoo_sample.cfg conf/zoo.cfg
$ bin/zkServer.sh start
$  jps
5193 QuorumPeerMain
5854 Jps
``````

The server command makes the Zookeeper server run in the background. We are now
ready to start a client.

``````
$ bin/zkCli.sh 
Connecting to localhost:2181
[...]
[zk: localhost:2181(CONNECTED) 0] ls /
[zookeeper]
[zk: localhost:2181(CONNECTED) 1] create myfolder ""
Created /myfolder
[zk: localhost:2181(CONNECTED) 2] ls /
[zookeeper, myfolder]
[zk: localhost:2181(CONNECTED) 3] quit

``````



## Zookeeper in Containers (Docker)
[TODO]


## Zookeeper cluster in OpenShift
[TODO]


