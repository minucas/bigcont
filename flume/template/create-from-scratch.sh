oc create -f flume-tier1-template.yaml
oc new-app flume-syslog-to-file 

# oc start-build flume-build
# oc deploy flume --latest -n metrics-data-pipeline
