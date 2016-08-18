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
$ bin/zkServer.sh stop

``````
So ZooKeeper allows distributed processes to coordinate with each other through
a shared hierarchal namespace which is organized similarly to a standard file
system. The name space consists of data registers - called znodes, in ZooKeeper
parlance - and these are similar to files and directories.

#### Simple session with Zookeeper in quorum mode:

We can run multiple servers even if we only have a single machine. We just
needo to set up a more sophisticated configuration, rather than the default.

In order for servers to contact each other, the need some contact information.
To accomplish this, we are going to use the following configuration file:

``````
$ cat conf/zoo.cfg
[...]
server.1=127.0.0.1:2222:2223
server.2=127.0.0.1:3333:3334
server.3=127.0.0.1:4444:4445
``````
Each server *.n* entry specifies the address and port numbers used by Zookeeper
server *n*. There are three colon-separated fields for each server *.n* entry,
the first field is the hostname or IP address of server *n*. The second and
third fields are TCP port numbers used for quorum communication and leader
selection. Because we are starting up three server processes on the same
machine, we need to use different port numbers for each entry. When running
each server process on its own host, each server entry will use the same port
numbers.

## Zookeeper in Containers (Docker)
[TODO]


## Zookeeper cluster in OpenShift
[TODO]


