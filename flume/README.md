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

> - the *source*

> - the *channel*

> - and *the sink*
    
A Flume source consumes events delivered to it by an external source.
When a Flume source receives an event, it stores it into one or more channels.
The channel is a passive store that keeps the event until it’s consumed by a
Flume sink. The sink removes the event from the channel and puts it into an
external repository like HDFS or to the next agent in the topology.

Other concepts to take into account in this quick overview are:

> - Interceptors

> - Channel Selectors

> - Sink Groups and Sink Processors

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

``````
$ wget http://www-eu.apache.org/dist/flume/1.6.0/apache-flume-1.6.0-bin.tar.gz
$ java -version
openjdk version "1.8.0_101"
$ tar xvzf apache-flume-1.6.0-bin.tar.gz
$ cd apache-flume-1.6.0-bin/
``````
We are explore a simple "hello world flume". The configuration file needs to
define the sources, the channels and the sinks. Sources, channels and sinks are
defined per agent, in this case called *agent*. So in the following
configuration file we have defined one agent (called *agent*) that has a source
named *s1*, a channel named *c1*, and a sink named *k1*.

The *s1* source's type is *netcat*, which simply opens a socket listening for
events (one line of text per event). It requires two parameters, a bind IP and
port number. In this example we are using 0.0.0.0 for a *bind* address (the
java convention to specify listen on any address) and *port 1234*. The source
configuration also has a parameter called *channels* (plural) that is the name
of the channel/channels the source will append events to, in this case *c1*. It
is plural because you can configure a source to write more than one channel.

The channel named *c1* is a *memory* channel with default configuration.

The sink named *k1* is of type *logger*. This is a sink that is mostly used for
debugging and testing. It will log all events at INFO level using log4j, which
it receives from the configured channel, in this case *c1*. Here the channel
keyword is singular because a sink can only fed data from one channel.

Using this configuration, let¡s run the agent and connect to it using the Linux
*netcat* utility to send an event.

``````
$ cat helloworld.conf 
agent.sources = s1
agent.channels = c1
agent.sinks = k1

agent.sources.s1.type = netcat
agent.sources.s1.channels = c1
agent.sources.s1.bind = 0.0.0.0
agent.sources.s1.port = 1234

agent.channels.c1.type = memory

# Each sink's type must be defined
agent.sinks.k1.type = logger

# Specify the channel the sink should use
agent.sinks.k1.channel = c1
``````
Next, you can start the agent. The *-Dflume.root.logger* property overrides the
root logger in conf/log4j.properties to use the console appener.

``````
$ bin/flume-ng agent -n agent -c conf -f helloworld.conf -Dflume.root.logger=INFO,console
``````
Finally, opening a second terminal, we'll use the netcat command (nc) to send 
the string "Hello World", and hit RETURN to mark the end of the event.

``````
$ nc localhost 1234
Hello Flume
OK
``````





## Flume in Containers (Docker)
[TODO]


## Flume data flows in OpenShift
[TODO]


