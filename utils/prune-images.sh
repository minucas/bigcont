# login -u system:admin
# oadm policy add-cluster-role-to-user system:image-pruner jromanes
# login -u jromanes
oc adm prune images
