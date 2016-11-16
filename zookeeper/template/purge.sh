# This command will delete this objects:
# oc get all --selector app=flumeapp

oc delete all -l application=zookeeperapp

oc delete template zookeeper-quorum
