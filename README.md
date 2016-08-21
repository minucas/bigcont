# Big Data Container Ecosystem for OpenShift/Kubernetes

This is a testing project for build a Big Data Ecosystem on top of OpenShift 
Origin.

I this project we explore the different alternatives to run Big Data workloads
in OpenShift Origin, the foundations for BDaaS - Big Data as a Service, agile
 development cycle (devops), rapid development, and so forth.

## Testbed environment

Rapid testing of artifacts of this project with new **oc cluster up** from 
v1.3.0-alpha.3:

1. Install Docker with your platform's package manager:

``````
Fedora 24: sudo dnf install docker
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
``````

5. To stop your cluster, run:

``````
$ oc cluster down
``````
```



