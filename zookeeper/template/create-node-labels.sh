oc login -u system:admin

# oc label node <node> <key_1>=<value_1> ... <key_n>=<value_n> [--overwrite]

oc label node oscpbigdata-node2.redhat.lan server-id='1'
oc label node oscpbigdata-node3.redhat.lan server-id='2'
oc label node oscpbigdata-node4.redhat.lan server-id='3'
