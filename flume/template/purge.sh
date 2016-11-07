# This command will delete this objects:
# oc get all --selector app=flumeapp

oc delete all -l application=flumeapp

oc delete template flume-syslog-to-file
