### Quick Background: MongoDB

MongoDB is a document-oriented database, a kind of NoSQL database, not a
relational one. NoSQL solutions were not created for the same purposes as SQL.
While SQL is mainly dedicated for structured data and to handle transactions,
NoSQL solutions were created to resolve the storage problems of massive
unstructured datasets.

NoSQL databases can be classied using different approaches and various criteria.
Some experts classify them according to their data model. MongoDB is
classified as Document Store or Document Oriented database.

A document-oriented database replaces the concept of a “row” with a more
flexible model, the “document”.

MongoDB was designed to scale out. Its document-oriented data model makes it 
easier for it to split up data across multiple servers. MongoDB automatically 
takes care of balancing data and load across a cluster, redistributing 
documents automatically and routing user requests to the correct machines.
Scale up the cluster (when we need more nodes) is as easy as to add new machines,
and MongoDB will figure out how the existing data should be spread to them.

### Why is important MongoDB in a Big Data ecosystem?

MongoDB is very scalable, has high reliability, low initial cost (low learning
curve). It is the foundation of a plethora of tools (as internal database) and
frequently is the NoSQL database of election for Big Data programmers: it's easy
to use. It's one of the most popular NoSQL databases in the Big Data scene.

### Getting started with MongoDB

In this "hello world mongodb" example we run the mongod process at the
system prompt, and handle the mongodb database with the "mongo Shell" tool.
When you run mongo without any arguments, the mongo shell will attempt to
connect to the MongoDB instance running on the localhost interface on port
27017.

In this example we create a new database "hellodb", and we create a new table
"users". In MongoDB, both database and table are created automatically when the
first time data is inserted. A table (SQL term) in MongoDB is a "collection".

``````
$ curl -O https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-amazon-3.2.9.tgz
$ tar xvzf mongodb-linux-x86_64-amazon-3.2.9.tgz
$ mv mongodb-linux-x86_64-amazon-3.2.9 mongodb
$ mkdir data
$ mongodb/bin/mongod --dbpath data/

$ mongodb/bin/mongo
MongoDB shell version: 3.2.9
connecting to: test
Welcome to the MongoDB shell.
> db
test
> use hellodb
switched to db hellodb
> db.users.insert({username:"user1",password:"123456"})
WriteResult({ "nInserted" : 1  })
> db.users.find()
{ "_id" : ObjectId("57d3a66e438d6b34b2e6a78d"), "username" : "user1", "password" : "123456"  }
> db.users.remove({username:"user1"})
> exit
``````

## MongoDB in Containers (Docker)

The MongoDB "helloworl Docker" is as simple as the following session:

``````
$ cd upstream
$ docker build -f Dockerfile.single -t bigcontainer/mongodb .
$ docker run --name=mongodb -d bigcontainer/mongodb
$ docker inspect mongodb | grep IPAddress
$ mongodb/bin/mongo --host 172.17.0.2
MongoDB shell version: 3.2.9
connecting to: 172.17.0.2:27017/test
> db
test
> exit
``````
By default, the mongod process uses the /data/db directory. This directory is
within the container, so is no useful at all, this is only a "hello world!".
A simple way to avoid this "ephemeral" behaviour of containers is to use A data
volume, which is a specially-designated directory within one or more containers that
bypasses the Union File System. Data volumes provide several useful features
for persistent data.

``````
$ mkdir -p data/db
$ chown -R root: data/
$ sudo chcon -Rt svirt_sandbox_file_t data/
$ docker build -f Dockerfile.single -t bigcontainer/mongodb .
$ docker run --name=mongodb -v $PWD/data:/data -d bigcontainer/mongodb
``````

### MongoDB clustering

Since version 1.6.0, MongoDB has included native support for database clusters
called “Replica Sets”. Moving beyond master-slave replication, these sets allow
a group of MongoDB instances to automatically negotiate which instances are
“master” and “slaves”. Replica sets are also able to renegotiate the master or
slave status of the nodes in the cluster in response to the status of
individual nodes. All members of Replica Sets are eventually consistent with
each other. Replica sets support clusters of up to seven MongoDB instances.

- Configure MongoDB Master-Slave Replication

One database server (the “master”) is in charge and can do anything.  A bunch
of other database servers keep copies of all the data that’s been written to
the master and can optionally be queried (these are the “slaves”).  Slaves
cannot be written to directly, they are just copies of the master database.
Setting up a master and slaves allows you to scale reads nicely because you can
just keep adding slaves to increase your read capacity.  Slaves also make great
backup machines. If your master explodes, you’ll have a copy of your data safe
and sound on the slave.


``````
$ docker build -f Dockerfile.masterslave -t bigcontainer/mongodb .
$ docker network create mynet
$ docker run -e "ROLE=master" --net=mynet --name=server1 -d bigcontainer/mongodb
$ docker run -e "ROLE=slave" --net=mynet --name=server2 -d bigcontainer/mongodb
$ docker inspect server1 | grep IPAddress
	172.19.0.2
$ docker inspect server2 | grep IPAddress
	172.19.0.3

$ mongodb/bin/mongo --host 172.19.0.2
> rs.printReplicationInfo()
configured oplog size:   990MB
log length start to end: 555secs (0.15hrs)
oplog first event time:  Sat Sep 10 2016 19:17:58 GMT+0200 (CEST)
oplog last event time:   Sat Sep 10 2016 19:27:13 GMT+0200 (CEST)
now:                     Sat Sep 10 2016 19:27:17 GMT+0200 (CEST)
> exit

$ mongodb/bin/mongo --host 172.19.0.3
> rs.printSlaveReplicationInfo()
source: server1:27017
        syncedTo: Sat Sep 10 2016 19:28:43 GMT+0200 (CEST)
        11 secs (0 hrs) behind the freshest member (no primary available at the moment)
> exit
``````

- Configure MongoDB Replica Sets

Replica Sets are a great way to replicate MongoDB data across multiple servers
and have the database automatically failover in case of server failure. Read
workloads can be scaled by having clients directly connect to secondary
instances. Note that master/slave MongoDB replication is not the same thing as
a Replica Set, and does not have automatic failover.

We will deploy a replica set called rs0. This replica set will have as primary
node mongo1 replicating to two secondary instances mongo2 and mongo3.

Three member replica sets provide enough redundancy to survive most network
partitions and other system failures. These sets also have sufficient capacity
for many distributed read operations. Replica sets should always have an odd
number of members. 

In this example, we will have a replica set (rs0) with a database
(mydb) and a collection (zip) on 3 servers (mongo1, mongo2,mongo3).

``````
$ docker build -f Dockerfile.replicaset -t bigcontainer/mongodb .
$ docker network create mynet
$ docker run --net mynet --name mongo1 -h mongo1 -d bigcontainer/mongodb
$ docker run --net mynet --name mongo2 -h mongo2 -d bigcontainer/mongodb
$ docker run --net mynet --name mongo3 -h mongo3 -d bigcontainer/mongodb
$ docker run --net mynet --name mongoshell -h mongoshell -it --entrypoint=/bin/bash -d bigcontainer/mongodb
$ docker attach mongoshell
[root@mongoshell /]# mongo --host=mongo1
MongoDB shell version: 3.2.9
connecting to: mongo1:27017/test
Welcome to the MongoDB shell.
> rs.initiate()
> rs.add("mongo1")
> rs.add("mongo2")
> rs.add("mongo3")
> rs.status()
> exit
[root@mongoshell /]# curl -O http://media.mongodb.org/zips.json
[root@mongoshell ~]# mongoimport --host rs0/mongo1:27017,mongo2:27017,mongo3:27017 --db mydb --collection zip --file zips.json
2016-09-11T16:53:08.359+0000    connected to:
rs0/mongo1:27017,mongo2:27017,mongo3:27017
2016-09-11T16:53:11.346+0000    [###############.........] mydb.zip 1.98MB/3.03MB (65.1%)
2016-09-11T16:53:12.952+0000    [########################] mydb.zip 3.03MB/3.03MB (100.0%)
2016-09-11T16:53:12.952+0000    imported 29353 documents
``````
- MongoDB Sharded Cluster

As we already know, A Replica-Set means that you have multiple instances of
MongoDB which each mirror all the data of each other. A replica-set consists of
one Master (also called "Primary") and one or more Slaves (aka Secondary).
Read-operations can be served by any slave, so you can increase
read-performance by adding more slaves to the replica-set (provided that your
client application is capable to actually use different set-members). But
write-operations always take place on the master of the replica-set and are
then propagated to the slaves, so writes won't get faster when you add more
slaves.

Other kind of configuration (clustered configuration), other than master-slave
or replica-set, is the sharded-cluster. With Sharded Clustering with use the
concept of "Sharding": Sharding is the process of storing data records across
multiple machines and it is MongoDB's approach to meeting the demands of data
growth. As the size of the data increases, a single machine may not be
sufficient to store the data nor provide an acceptable read and write
throughput. Sharding solves the problem with horizontal scaling. 

In a MongoDB Sharded Cluster, each shard of the cluster (which can
also be a replica-set) takes care of a part of the data. Each request, both
reads and writes, is served by the cluster where the data resides. This means
that both read- and write performance can be increased by adding more shards to
a cluster. 

In a Sharded Cluster, another 2 new roles will be added: mongos and mongod
config. mongos is a routing service for MongoDB Sharded Clusters, it determines
the location of the data in the cluster, and forwards operations to the right
shard. mongos requires mongod config, which stores the metadata of the cluster.

We are not goint to practise this cluster schema in this Docker section, we will 
study this architecture in the OpenShift advanced section.

## Zookeeper cluster in OpenShift


