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
- Channel Selectors
- Sink Groups and Sink Processors

**Interceptors** are simple pluggable components that sit between a source and the
channel(s) it writes to. With Interceptors Flume has the capability to modify
and drop events in-flight based on some processing it does. Each source can be
configured to use multiple interceptors, which are called in the order defined
by the configuration. This is called the *chain-of-responsibility design
pattern*. Interceptors can be used to drop events based on some criteria, like
a regex, add new headers to events or remove existing ones, data enrichment,
etc.

**Channel Selectors** are those component of Flume that determines which channel
a particular Flume event should go into. For example the event can be written
to all of the channels or to just one based on some Flume header value.

**Sink Groups and Sink Processors**. In order to remove single points of failure in
the data processing pipeline, Flume has the ability to send events to different
sinks using either load balancing or failover. A Sink Group is used to create a
logical grouping of sinks, the behaviour of this groupping is dictated by the
Sink Processor, which determines how events are routed.

### Why is important Apache Flume in a Big Data ecosystem?

Traditionally, Flume has been the recommended system for streaming ingestion by
Cloudera, and it is a foundational part of architectural patterns for near
Real-Time Data Processing with Apache Hadoop proposal by Cloudera.

### Getting started with Flume
[TODO]


``````

``````

## Flume in Containers (Docker)
[TODO]


## Flume data flows in OpenShift
[TODO]


