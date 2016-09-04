for i in 1 2 3; do
cat <<! | oc create -f -
apiVersion: v1
kind: Service
metadata:
  name: service-server$i
spec:
  ports:
  - port: 2181
    name: "zookeeper-client-port"
    protocol: TCP
    targetPort: 2181
  - port: 2888
    name: "zookeeper-peer-port"
    protocol: TCP
    targetPort: 2888
  - port: 3888
    name: "zookeeper-election-port"
    protocol: TCP
    targetPort: 3888
  selector:
    server: "$i"
!
done
