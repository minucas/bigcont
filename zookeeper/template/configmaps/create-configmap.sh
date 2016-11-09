oc create configmap zk-1-config --from-file=zk-1/
oc create configmap zk-2-config --from-file=zk-2/
oc create configmap zk-3-config --from-file=zk-3/

# oc delete configmap zk-1-config zk-2-config zk-3-config
