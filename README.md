# Big Data Container Ecosystem for OpenShift/Kubernetes

This is a testing project for build a Big Data Ecosystem on top of OpenShift 
Origin.

I this project we explore the different alternatives to run Big Data workloads
in OpenShift Origin, the foundations for BDaaS - Big Data as a Service, agile
development cycle (devops), rapid development, and so forth.

## Rapid Testbed Environment

Rapid artifact testing of this project with the new **oc cluster up** command 
from v1.3.0-alpha.3 OpenShift Origin version:

1. Install Docker with your platform's package manager:

    ``````
    (Fedora 24)
    $ sudo dnf install docker
    ``````

2. Configure the Docker daemon with an insecure registry parameter of
`172.30.0.0/16` In RHEL and Fedora, edit the `/etc/sysconfig/docker` file and 
add or uncomment the following line:

    ``````
    INSECURE_REGISTRY='--insecure-registry 172.30.0.0/16'
    $ sudo systemctl restart docker
    ``````

3. Download the Linux `oc` binary from
   [openshift-origin-client-tools-v1.3.0-alpha.3-7998ae4-linux-64bit.tar.gz](https://github.com/openshift/origin/releases/download/v1.3.0-alpha.3/openshift-origin-client-tools-v1.3.0-alpha.3-7998ae4-linux-64bit.tar.gz)

4. Open a terminal with a user that has permission to run Docker commands and
   run:

    ``````
    $ oc cluster up
       [...]
       OpenShift server started.
       The server is accessible via web console at:
           https://192.168.43.137:8443

       You are logged in as:
           User:     developer
           Password: developer

       To login as administrator:
           oc login -u system:admin
    ``````

5. To stop your cluster, run:

    ``````
    $ oc cluster down
    ``````

Note: By default, etcd data will not be preserved between container restarts.
If you wish to preserve your data, specify a value for **--host-data-dir** and the
**--use-existing-config** flag.


Default routes are setup using xip.io and the host ip of your cluster. To use a
different routing suffix, use the **--routing-suffix** flag.

## Advanced Testbed Environment

[Advanced testbed notes](testbed/README.md)

## Working status

The following is a table with the working status for each tool.

| Tool | Overview | Docker | OpenShift manually | Template |
| :--  |:--------:|:------:|:------------------:|:--------:|
|[Apache Flume](flume/README.md)| Done | Done | Done | TODO |
|[Apache Zookeeper](zookeeper/README.md)| Done | Done | Done | TODO |
|[MongoDB](mongodb/README.md)| Done | TODO | TODO | TODO |
|[TensorFlow](tensorflow/README.md)| Done | TODO | TODO | TODO |
|[LogStash](logstash/README.md)| Done | TODO | TODO | TODO |



