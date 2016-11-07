# OpenShift Origin Testbed based on Vagrant

This is a Vagrant Project for OpenShift Origin.

# Usage

``````
$ vagrant --version
Vagrant 1.8.1

$ vagrant plugin list
vagrant-libvirt (0.0.35)

$ source env-setup
$ vagrant up

Current machine states:

mn                        running (libvirt)
master                    running (libvirt)
node1                     running (libvirt)
node2                     running (libvirt)
node3                     running (libvirt)
node4                     running (libvirt)
``````

The host roles are probably obvious:

* **mn**: Management Node (oc client, wildcard DNS, NFS server, FreeIPA
  management Identity)
* **master**: OpenShift Master Node
* **node1**: OpenShift Worker Node (Infra Node)
* **node[2-4]**: OpenShift Regular Worker Node 

The regular worker nodes are deployed with three disk attached, simulating JBOD
(“just a bunch of disks”). An Direct Attached Storage (DAS) array in each node.

With this configuration we will explore particular configurations focused in
data locality (In short, keep data on disks that are close to the CPU and RAM
that will be used to process and store it).


![Testbed Diagram](https://github.com/bigcontainer/bigcont/blob/master/testbed/ocptestbed/img/vagrant-simple-testbed.png)
