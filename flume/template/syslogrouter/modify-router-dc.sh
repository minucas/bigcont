oc env dc/router TEMPLATE_FILE=/var/lib/haproxy/conf/custom/haproxy-config.template
oc volume dc/router --add --overwrite \
    --name=config-volume \
    --mount-path=/var/lib/haproxy/conf/custom \
    --source='{"configMap": { "name": "customrouter" }}'
