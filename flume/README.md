## Quick Background: Apache Flume

Flume was first introduced in Cloudera's CDH3 Distribution in 2011, a few
months later Cloudera moved control of Flume project to the Apache Foundation.

Flume is specifically designed to push data from a massive number of sources to
the various storage systems (or backend systems) in the Hadoop ecosystem, like
HDFS, HBase, ElasticSearch, Hive, Solr, Kafka, and so on. So Apache Flume is a
well designed tool to managing massive data ingestion flows to Big Data
processing systems.

Flume is designed to be a flexible distributed system that can scale out very
easily and is highly customizable. A correctly configured Flume agent and a
pipeline of Flume agents created by connecting agents with each other is
guaranteed to not lose data (by means of durable channels).

The simplest unit of Flume deployment is a Flume agent. It is possible to
connect one Flume agent to one or more other agents. It is also possible for an
agent to receive data from one or more agents. By connecting multiple Flume
agents to each other, a flow is established (multi-hop flows). This chain of
Flume agents can be used to move data from one location to another.

Each Flume agent has three components:

- the *source*
- the *channel*
- and *the sink*
    
A Flume source consumes events delivered to it by an external source.
When a Flume source receives an event, it stores it into one or more channels.
The channel is a passive store that keeps the event until it’s consumed by a
Flume sink. The sink removes the event from the channel and puts it into an
external repository like HDFS or to the next agent in the topology.

Other concepts to take into account in this quick overview are:

- Interceptors
- Channel selectors
- Sink Groups and Sink Processors


### Why is important Apache Flume in a Big Data ecosystem?


### Getting started with Flume
[TODO]


``````

``````

## Flume in Containers (Docker)
[TODO]


## Flume data flows in OpenShift
[TODO]


