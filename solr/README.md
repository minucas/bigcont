## Quick Background: Apache Solr

Apache Solr, is a specific No SQL technology, optimized for a unique class of
problems: Solr is a scalable, enterprise search engine that’s optimized to search
large volumes of text-centric data.

Search engines like Solr are optimized to handle data exhibiting four main 
characteristics:

* Text-centric
* Read-dominant
* Document-oriented
* Flexible schema

**Text-centric** a search engine is specifically designed to extract the implicit 
structure of text into its index to improve searching. Text-centric data implies
that the text of a document contains information that users are interested in 
finding.

**Read-dominant** key aspect of data that search engines handle effectively is 
that data is read-dominant and therefore intended to be accessed efficiently, 
as opposed to updated frequently. A search engine has been optimized for 
executing queries (a read operation), for example, as opposed to storing 
data (a write operation).

**Document-oriented** search engines work with documents. In a search engine, a 
document is a self-contained collection of fields, in which each field only holds 
data and doesn’t contain nested fields. In other words, a document in a search 
engine like Solr has a flat structure and doesn’t depend on other documents. 
The flat concept is slightly relaxed in Solr, in that a field can have multiple 
values, but fields don’t contain subfields. You can store multiple values in a 
single field, but you can’t nest fields inside of other fields.

**Flexible schema** The last main characteristic of search-engine data is that
it has a flexible schema. This means that documents in a search index don’t need 
to have a uniform structure. In a relational database, every row in a table has 
the same structure. In Solr, documents can have different fields.

Search engines in general and Solr in particular are optimized to handle data 
having four specific characteristics: text-centric, read-dominant, 
document-oriented, and flexible schema. Overall, this implies that **Solr is not 
a general-purpose data-storage and processing technology.**

## Why is important Apache Solr in a Big Data ecosystem?

Apache Solr is a powerful enterprise search package that lets you run a variety
of advanced and complex searches on textual content. We are able to search in
text with different tools in the Big Data context. Nevertheless as Cloudera
product manager said "Tens of thousands of people know how to write MapReduce,
millions of people can do SQL queries, but billions of people know how to use a
search engine". 

Cloudera, Hortonworks and MapR are selected Apache Solr as top level layer on
top of Apache Lucene.

## Understanding Solr Data Model and Core Concepts

A **document** represents the basic and atomic unit of information in Solr. It is a
container of fields and values that belong to a given entity of your domain
model (a book, a metric, a person). You can think of a document as a record in
a relational database.

Solr is a document storage and retrieval engine. Every piece of data submitted
to Solr for processing is a document.  

Each document contains one or more **fields**, each of which is modeled as a 
particular field type: string, tokenized text, Boolean, date/time, lat/long, etc.
The number of potential field types is infinite because a field type is composed
of zero or more analysis steps that change how the data in the field is processed
and mapped into the **Solr index** (Solr index is underlayed by Lucene Inverted Index).

A search index is similar to a databse index: is a data structure that
improves the speed of data retrieval operations.

Each field in a document is defined in **Solr’s schema** as a particular field type, 
which allows Solr to know how to handle the content as it’s received.

When we run a query against Solr, we can search on one or more of these fields, 
and Solr will return documents that contain content in those fields matching the query.  

All field types must be defined, and all field names (or dynamic field-naming 
patterns) should be specified in **Solr’s schema.xml**. This does not mean that
every document must contain every field, only that all possible fields must be 
mappable to a particular field type should they appear in a document and need to
be processed. Solr does contain an ability to automatically guess the field type
for previously unseen field names when it first receives a document with a new 
field name. This is accomplished by inspecting the type of data in the field and 
automatically adding the field to Solr’s schema. Since Solr could potentially 
guess the wrong field type if the input is confusing, it’s a better practice to 
predefine the field in the schema.xml file.

So, A document, then, is a collection of fields that map to particular field 
types defined in a schema. Each field in a document has its content analyzed 
according to its field type, and the results of that analysis are saved into 
a search index in order to later retrieve the document by sending in a related 
query. The primary search results returned from a Solr query are documents 
containing one or more fields.

## Searching at scale: Distributed searching

In order to run queries at scale, we need more than one single huge server, we need
scale-up the engine into separated severs.

It’s necessary to break your content into two or more separate Solr indexes, each 
of which contains separate partitions of your data. Then every time a search is 
run, it’ll be sent to both servers, and the separate results will be processed 
and aggregated before being returned from the search engine.

So with Apache Solr, it is possible to partition your content across multiple Solr indexes 
(called **sharding**), as well as to create multiple copies of any partition of 
the data (called **replication**).

To accomplish this Apache Solr can be run in **SolrCloud Mode**: SolrCloud is
designed to provide a highly available, fault tolerant environment for
distributing your indexed content and query requests across multiple servers 
(aka Solr Cluster). It's a system in which data is organized into multiple pieces,
or shards, that can be hosted on multiple machines, with replicas providing 
redundancy for both scalability and fault tolerance (so a replica is one copy of 
a shard), and a **ZooKeeper server** that helps manage the overall structure 
so that both indexing and search requests can be routed properly.

The SolrCloud concept: A SolrCloud cluster consists of some "logical"
concepts layered on top of some "physical" concepts.

 1. Logical:

    - A SolrCluster can host multiple Collections of Solr Documents.
    - A collection can be partitioned into multiple Shards, which contain a
      subset of the Documents in the Collection. The collection is Logical
      Index.
    - The number of Shards that a Collection has determines:
        - The theoretical limit to the number of Documents that Collection can
          reasonably contain.
        - The amount of parallelization that is possible for an individual
          search request.

 2. Physical:

    - A Cluster is made up of one or more Solr Nodes, which are running
      instances of the Solr server process. In SolrCloud, a node is Java
      Virtual Machine instance running Solr, commonly called a server.  
    - A cluster is set of Solr nodes managed by ZooKeeper as a single unit.
    - Each Node can host multiple Solr Cores: A Solr core is basically an index
      of the text and fields found in documents. A single Solr instance can
      contain multiple "cores".
    - Each Core in a Cluster is a physical Replica for a logical Shard.
    - Every Replica uses the same configuration specified for the Collection
      that it is a part of.
    - The number of Replicas that each Shard has determines:
        - The level of redundancy built into the Collection and how fault
          tolerant the Cluster can be in the event that some Nodes become
          unavailable.
        - The theoretical limit in the number concurrent search requests that
          can be processed under heavy load.

In SolrCloud mode you to create multiple search indexes, each of which is 
represented by a Solr core. A Solr core is a uniquely named, managed, and 
configured index running in a Solr server (important, this concept is in 
the context of a single server); a Solr server can host one or more cores. 
A core is typically used to separate documents that have different schemas.
SolrCloud introduces the concept of a **collection**, which extends the concept of
a uniquely named, managed, and configured index to one that is split into shards
and distributed across multiple servers. The reason SolrCloud needs a new term
is because each shard of a distributed index is hosted in a Solr core.

When talking about SolrCloud, it helps to no longer think in terms of cores, 
but rather to think of shards, which are mutually exclusive slices of an index. 
The fact that a shard is backed by a Solr core is simply an implementation detail.

Just as a single Solr server can host multiple cores, a SolrCloud cluster can 
host multiple collections. If you need to represent documents with different 
schemas, you will use multiple collections in SolrCloud as you would use multiple 
cores in a single server setup.

A note about Apache Zookeeper, which is a critical component in the
SolrCloud architecture. ZooKeeper is a coordination service for distributed
systems. Solr uses ZooKeeper for three critical operations:

 - Centralized configuration storage and distribution
 - Detection and notification when the cluster state changes
 - Shard-leader election

Shard leader: A shard leader is responsible for accepting update requests
(document additions or deletions) for the shard handled and distributing them 
to replicas in a coordinated fashion. Specifically:

 - Accepts update requests for the shard: responsible of shard handled.
 - Sends the update (in parallel) to all replicas of the shard, and blocks
   until a response is received.

The concept of a leader is similar to that of master when thinking of
traditional Solr replication. The leader is responsible for making sure the
replicas are up to date with the same information stored in the leader.

Note: Traditional Solr Replication - It is considered "legacy" behavior, since
while it is still supported in Solr, the SolrCloud functionality is where 
the current development is headed. In the traditional Solr replication, the index
replication distributes complete copies of a master index to one or more slave
servers. The master server continues to manage updates to the index. All
querying is handled by the slaves.

Any host per shard can be the leader, and all other hosts per shard are replicas. 
As with replicas, leaders also participate in distributed queries.  Contrast this 
with a master-slave setup in which master nodes only index, and slave nodes only 
respond to queries. In SolrCloud, both leaders and replicas perform indexing and execute queries.
If the current Shard Leader goes down, a new node will automatically be elected 
to take it's place.

It’s important to know that you really shouldn’t care which node in a shard is 
the current leader and shouldn’t try to control it. SolrCloud was designed so 
that any host for a shard could be the leader, and a new leader can be elected automatically.

### Creating shards and replicas

When creating a collection in SolrCloud we can adjust the creation command.
Some of the parameters are mandatory, some of them have defaults and can be
overwritten. The two main parameters we are interested in are the number of
shards and the replication factor. The former tells Solr how to divide the
collection – how many distinct pieces (shards) our collection will be split
into. For example, if we say that we want to have four shards Solr will divide
the collection into four pieces, with each piece having about 25% of the
documents. The replication factor on the other hand dictates the number of
physical copies that each shard will have. So, when replication factor is set
to 1, only leader shards will be created. If replication factor is set to 2
each leader will have one replica, if replication factor is set to 3 each
leader will have two replicas and so on.

By default, Solr will put one shard of a collection on a given node. If we want
to have more shards than the number of nodes we have in the SolrCloud cluster,
we need to adjust the behavior, which we also can do by using Collections API.
Of course, Solr will try to spread the shards evenly around the cluster, but we
can also adjust that behavior by telling Solr on which nodes shards should be
created.

## Getting started with Solr

``````
$ curl -O http://www-eu.apache.org/dist/lucene/solr/6.3.0/solr-6.3.0.tgz
$ tar xvzf solr-6.3.0.tgz
$ cd solr-6.3.0/
$ bin/solr start -e cloud -noprompt
Welcome to the SolrCloud example!

Starting up 2 Solr nodes for your example SolrCloud cluster.

[...]

Starting up Solr on port 8983 using command:
bin/solr start -cloud -p 8983 -s "example/cloud/node1/solr"

Waiting up to 180 seconds to see Solr running on port 8983 [\]  
Started Solr server on port 8983 (pid=6800). Happy searching!

Starting up Solr on port 7574 using command:
bin/solr start -cloud -p 7574 -s "example/cloud/node2/solr" -z localhost:9983

[...]
``````
You can see that the Solr is running by loading the Solr Admin UI in your web
browser: http://localhost:8983/solr/. This is the main starting point for
administering Solr.

The "getting started example": Solr will now be running two "nodes", one on
port 7574 and one on port 8983. There is one collection created automatically,
gettingstarted, a two shard collection, each with two replicas. You can take
a look of this collection in a diagram in the Cloud Tab -> Graph UI.

The Solr server is up and running, but it doesn't contain any data. The Solr
install includes the bin/post tool in order to facilitate getting various types
of documents easily into Solr from the start. We'll be using this tool for the
indexing examples.

Indexing a directory: bin/post features the ability to crawl a directory of
files, optionally recursively even, sending the raw content of each file into
Solr for extraction and indexing. A Solr install includes a docs/ subdirectory,
so that makes a convenient set of (mostly) HTML files built-in to start with.


``````
$ bin/post -c gettingstarted docs/

[...]

POSTing file SolrCellBuilder.html (text/html) to [base]/extract
Indexing directory docs/changes (1 files, depth=1)
POSTing file Changes.html (text/html) to [base]/extract
4405 files indexed.
COMMITting Solr index changes to
http://localhost:8983/solr/gettingstarted/update...
Time spent: 0:01:22.673
``````
The command-line breaks down as follows:

``````
    -c gettingstarted: name of the collection to index into
    docs/: a relative path of the Solr install docs/ directory
``````


## Solr in Containers (Docker)

## Solr cluster in OpenShift





