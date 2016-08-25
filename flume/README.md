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

The *s1* source's type is *http*, source which accepts Flume Events by HTTP
POST and GET. GET should be used for experimentation only. It requires two 
parameters, a bind IP and port number. In this example we are using 0.0.0.0 for
a *bind* address (the java convention to specify listen on any address) and 
*port 1234*. The source configuration also has a parameter called *channels* 
(plural) that is the name of the channel/channels the source will append events
to, in this case *c1*. It is plural because you can configure a source to write
more than one channel.

The channel named *c1* is a *memory* channel with default configuration.

The sink named *k1* is of type *logger*. This is a sink that is mostly used for
debugging and testing. It will log all events at INFO level using log4j, which
it receives from the configured channel, in this case *c1*. Here the channel
keyword is singular because a sink can only fed data from one channel.

Using this configuration, let's run the agent and connect to it using the some
regular HTTP client utility to send an event.

``````
$ cat helloworld.conf 
agent.sources = s1
agent.channels = c1
agent.sinks = k1

agent.sources.s1.type = http
agent.sources.s1.handler = org.apache.flume.source.http.JSONHandler
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
$ bin/flume-ng agent -n agent -c conf -f hello-world.conf -Dflume.root.logger=INFO,console
``````
Finally, opening a second terminal, we'll use the *curl* command to send a
JSON file with "Hello World". 

``````
$ curl -X POST \
    -H 'Content-Type: application/json; charset=UTF-8' \
    -d '[{"headers":{"header.key":"header.value"}, "body":"hello world"}]' \  
    http://localhost:1234 
``````
## Flume in Containers (Docker)
As usual, run a simple java based program within a container is easy:

``````
$ docker build -f Dockerfile -t bigcontainer/flume .
$ docker run bigcontainer/flume
$ docker ps
$ docker inspect prickly_keller | grep IPAddress

$ curl -X POST \
    -H 'Content-Type: application/json; charset=UTF-8' \
    -d '[{"headers":{"header.key":"header.value"}, "body":"hello world"}]' \  
    172.17.0.2:1234 
``````
## Flume data flow in OpenShift

The simplest way to bring our containerized Apache Flume to OpenShift is by
means of creating an OpenShift Application (*oc new-app*). This method
delegates to OpenShift the creaion of necessary objects for run our contaniner.

Particulary we are going to creating an application using the variant 
"Remote Git Source Build Strategy". OpenShift will detect a Build Strategy, in
this case will be a Docker build strategy, because we have a *Dockerfile* in
the top folder of our git repository.

The automatically generated OpenShift objects are:

1. An *Image Stream* that will track this image creation.
2. A *Build Config* strategy is created.
2. The created image is deployed with a *Deployment Config*.
3. A *Service* is created for internal load balancing.
4. A *Replication Controller* is created for pod scaling.

The only manual step with have to do is to expose a *Route* to the exterior.
By default, the new-app command does not expose the Service it creates to the
outside world. If you want to expose a Service as an HTTP endpoint you to to do
it manually.
``````
$ oc cluster up
$ oc login -u system:admin
$ oc get pod --all-namespaces
$ oc project default
$ oc describe pod router-1-kb10r  | grep  IP
IP:        192.168.1.44

$ oc login -u developer
$ oc new-app https://github.com/bigcontainer/bigcont \
	--context-dir=flume \
	--name=flume-service
$ oc logs bc/flume-service -f
$ oc expose --hostname=flume.192.168.1.44.xip.io svc flume-service


$ oc logs pod flume-service-1-7mmu0 -f
$ curl -X POST \
    -H 'Content-Type: application/json; charset=UTF-8' \
    -d '[{"headers":{"header.key":"header.value"}, "body":"hello world"}]' \  
	flume.192.168.1.44.xip.io
``````
To take a look to the created objects:

``````
$ oc status -v
In project My Project (myproject) on server https://192.168.1.44:8443

svc/flume-service - 172.30.99.49:1234
  dc/flume-service deploys istag/flume-service:latest <-
    bc/flume-service docker builds https://github.com/bigcontainer/bigcont#flume-service on istag/centos:7 
    deployment #1 deployed 44 seconds ago - 1 pod

$ oc get is
NAME            DOCKER REPO                                  TAGS      UPDATED
centos          172.30.56.108:5000/myproject/centos          7         3 minutes ago
flume-service   172.30.56.108:5000/myproject/flume-service   latest    2 minutes ago
$ oc get bc
NAME            TYPE      FROM                LATEST
flume-service   Docker    Git@flume-service   1
$ oc get dc
NAME            REVISION   DESIRED   CURRENT   TRIGGERED BY
flume-service   1          1         1         config,image(flume-service:latest)
$ oc get svc
NAME            CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE
flume-service   172.30.99.49   <none>        1234/TCP   4m
$ oc get rc
NAME              DESIRED   CURRENT   AGE
flume-service-1   1         1         2m
$ oc get route
NAME            HOST/PORT                   PATH      SERVICE                  TERMINATION   LABELS
flume-service   flume.192.168.1.44.xip.io             flume-service:1234-tcp                 app=flume-service
``````
We can scale our Apache Flume ingestion cluster with:

``````
$ oc scale --replicas=3 rc flume-service-1
$ oc get pod
NAME                    READY     STATUS      RESTARTS   AGE
flume-service-1-23k9x   1/1       Running     0          7m
flume-service-1-5n71o   1/1       Running     0          55s
flume-service-1-xkspu   1/1       Running     0          55s
``````
An the always useful web console screenshot:

[[https://github.com/bigcontainer/bigcont/blob/flume-service/flume/img/screenshot-flume-cluster.png|alt=flume]]


