## Quick Background: Apache Kafka

Apache Kafka is a publish/subscribe messaging system, it is often described as a
“distributed commit log”. A filesystem or database commit log is designed to 
provide a durable record of all transactions so that they can be replayed to 
consistently build the state of a system. Similarly, data within Kafka is 
stored durably, in order, and can be read deterministically.

Message publishing is a mechanism for connecting various applications with the
help of messages that are routed between. Kafka provides seamless integration
between information from producers and consumers without blocking the producers 
of the information and without letting producers know who the final consumers 
are.

Apache Kafka is a distributed, partitioned, and replicated commit-log-based 
publish-subscribe messaging system, mainly designed with the following 
features:

- Persistent messaging: Apache Kafka is designed with O(1)
disk structures that provide constant-time performance even with very
large volumes of stored messages that are in the order of TBs. With Kafka,
messages are persisted on disk as well as replicated within the cluster to
prevent data loss.

- High throughput: Kafka is designed to work on commodity hardware and to handle 
hundreds of MBs of reads and writes per second from large number of clients.

- Distributed: Apache Kafka with its cluster-centric design explicitly supports
message partitioning over Kafka servers and distributing consumption over
a cluster of consumer machines while maintaining per-partition ordering
semantics. Kafka cluster can grow elastically and transparently without
any downtime.

- Real time: Messages produced by the producer threads should be
immediately visible to consumer threads; this feature is critical to event-
based systems such as Complex Event Processing (CEP) systems.

## Why is important Apache Kafka in a Big Data ecosystem?

Apache Kafka was designed to provide the circulatory system for a data ecosystem. 
It carries messages between the various members of the infrastructure, providing 
a consistent interface for all clients. When coupled with a system to provide 
message schemas, producers and consumers no longer require a tight coupling, or 
direct connections of any sort. Components can be added and removed as business 
cases are created and dissolved, while producers do not need to be concerned 
about who is using the data, or how many consuming applications there are.

Apache Kafka has quickly grown into a de facto standard for data storage with
stream processing frameworks. All the major frameworks, including Samza, Spark
Streaming, and Storm, include robust and actively-maintained connectors. It has
achieved this status because it is a natural fit for streaming data: high
throughput, low latency, scales to very large workloads, and uses retention
policies to explicitly limit the stored data, something that needs to be done
manually with most data stores. And it’s not only good for input and output;
it’s also ideal for intermediate storage of derived data streams that may feed
back into additional downstream processing jobs.

## Getting started with Kafka

``````
$ wget http://www-eu.apache.org/dist/flume/1.6.0/apache-flume-1.6.0-bin.tar.gz
``````
## Kafka in Containers (Docker)

## Kafka cluster in OpenShift

