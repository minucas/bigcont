#oc new-project metrics-data-pipeline \
#    --description="This is an example project to demonstrate Apache Flume Service" \
#    --display-name="Apache Flume Testing"

oc create -f flume-tier1-template.yaml
oc new-app flume-syslog-to-file 

# oc start-build flume-build
# oc deploy flume --latest -n metrics-data-pipeline


