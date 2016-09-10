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

``````
$ mkdir -p data/db
$ chown -R root: data/
$ sudo chcon -Rt svirt_sandbox_file_t data/
$ docker build -f Dockerfile.cluster -t bigcontainer/mongodb .
$ docker run --name=mongodb-server1 -v $PWD/data:/data -d bigcontainer/mongodb
``````


## Zookeeper cluster in OpenShift


