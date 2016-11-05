oc create configmap rsyslog-tier1-test \
    --from-file=rsyslog-tier1-test.conf \
    --from-file=log4j.properties
