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
dataDir=/tmp/zookeeper
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

We also need to set up some *data directories*, and this is a key point
regarding OpenShift Pods. When we start up a server, it needs to know which
server it is. A server figures out this ID by reading a file named *myid* in
the *data* directory (it finds the *data* directory using the **dataDir**
parameter in the configuration file). We can do this from the command line with
the following commands:

``````
$ cd /tmp/zookeeper
$ mkdir -p z{1,2,3}/data
$ echo 1 > z1/myid
$ echo 2 > z2/myid
$ echo 3 > z3/myid
``````
We need three configuration files, because we are running in the same host,
with the following particular changes:

``````
$ cat conf/z1.conf
[...]
dataDir=/tmp/zookeeper/z1
clientPort=2181
server.1=127.0.0.1:2222:2223
server.2=127.0.0.1:3333:3334
server.3=127.0.0.1:4444:4445 
$ cat conf/z2.conf
[...]
dataDir=/tmp/zookeeper/z2
clientPort=2182
server.1=127.0.0.1:2222:2223
server.2=127.0.0.1:3333:3334
server.3=127.0.0.1:4444:4445 
$ cat conf/z3.conf
[...]
dataDir=/tmp/zookeeper/z3
clientPort=2183
server.1=127.0.0.1:2222:2223
server.2=127.0.0.1:3333:3334
server.3=127.0.0.1:4444:4445 

``````
The complete session:

``````
$ bin/zkServer.sh start conf/z1.conf 
Using config: conf/z1.conf
Starting zookeeper ... STARTED
$ bin/zkServer.sh start conf/z2.conf 
Using config: conf/z2.conf
Starting zookeeper ... STARTED
$ bin/zkServer.sh start conf/z3.conf 
Using config: conf/z3.conf
Starting zookeeper ... STARTED
$ jps
8226 Jps
8137 QuorumPeerMain
8188 QuorumPeerMain
7967 QuorumPeerMain
$ bin/zkCli.sh -server 127.0.0.1:2181,127.0.0.1:2182,127.0.0.1:2183
[zk: 127.0.0.1:2181,127.0.0.1:2182,127.0.0.1:2183(CONNECTED) 0] quit
$ bin/zkServer.sh stop conf/z1.conf
$ bin/zkServer.sh stop conf/z2.conf
$ bin/zkServer.sh stop conf/z3.conf
``````

With this information we can start to study Zookeeper in containers and
OpenShift.

## Zookeeper in Containers (Docker)

A simple Docker container running Apache Zookeeper is quite simple.

``````
$ docker build -f Dockerfile.single -t bigcontainer/zookeeper .
$ docker run --name=zookeeper -d bigcontainer/zookeeper
$ docker ps
$ docker inspect zookeeper | grep IPAddress
$ bin/zkCli.sh  -server 172.17.0.2:2181
[zk: 172.17.0.2:2181(CONNECTED) 0] ls /
[zookeeper]
[zk: 172.17.0.2:2181(CONNECTED) 1] quit
``````
However only one Zookeeper server is not useful at all. We have to create a
Zookeeper Essemble with at least three server to fulfil a quorum. Here is where
the task is not trivial: all of the servers need to be aware of each other. We
have to create multiple containers from the same image and have them point to
each other.

With User-Defined Networks (Docker 1.9.0 +) we can connect containers placing
them in the same network or sub-network.
``````
$ docker build -f Dockerfile.ensemble -t bigcontainer/zookeeper .
$ docker network create mynet
$ docker network ls
$ docker run -e "MYID=1" --net=mynet --name=server1 -d bigcontainer/zookeeper 
$ docker run -e "MYID=2" --net=mynet --name=server2 -d bigcontainer/zookeeper 
$ docker run -e "MYID=3" --net=mynet --name=server3 -d bigcontainer/zookeeper 
$ docker exec -it server1 /bin/bash
[89dd8c7418c9 /]# /opt/zookeeper/bin/zkCli.sh -server server1:2181,server2:2181,server3:2181
[zk: server1:2181,server2:2181,server3:2181(CONNECTED) 0] create /zk_test my_data
Created /zk_test
[zk: server1:2181,server2:2181,server3:2181(CONNECTED) 1] ls /
[zookeeper, zk_test]
[zk: server1:2181,server2:2181,server3:2181(CONNECTED) 2] get /zk_test
my_data
cZxid = 0x100000002
ctime = Mon Aug 29 12:27:10 UTC 2016
mZxid = 0x100000002
mtime = Mon Aug 29 12:27:10 UTC 2016
pZxid = 0x100000002
cversion = 0
dataVersion = 0
aclVersion = 0
ephemeralOwner = 0x0
dataLength = 7
numChildren = 0
[zk: server1:2181,server2:2181,server3:2181(CONNECTED) 3] quit
``````

## Zookeeper cluster in OpenShift
We are creating raw pods for this example, probalby it not the best practice,
as well pods only take full docker pull specs for the image path. they do not
understand imagestreams, so there is no "correct" way to reference an
imagestream from a pod, so we have to referencence the registry service IP. 
Anyway this is only for understanding the pains behind this approach.

An important thing to note is that ports 2181, 2888, and 3888 should be open
across all three machines. In this example, config, port 2181 is used by
ZooKeeper clients to connect to the ZooKeeper servers, port 2888 is used by
peer ZooKeeper servers to communicate with each other, and port 3888 is used
for leader election. You may chose any ports of your liking. It's usually
recommended that you use the same ports on all of the ZooKeeper servers.
``````
$ oc login -u system:admin
$ REG=$(oc --namespace=default get svc docker-registry --template={{.spec.portalIP}}):5000
$ oc adm policy add-role-to-user system:registry developer
$ oc adm policy add-role-to-user system:image-builder developer

$ oc login -u developer
$ docker login -u $(oc whoami) -p $(oc whoami -t) -e none $REG

$ docker build -t bigcontainer/zookeeper .
$ docker tag bigcontainer/zookeeper $REG/myproject/zookeeper
$ docker push $REG/myproject/zookeeper

$ export REG
$ sh create-services.sh 
$ sh create-pods.sh 
``````

