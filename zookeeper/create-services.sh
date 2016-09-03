for i in 1 2 3; do
cat <<! | oc create -f -
apiVersion: v1
kind: Service
metadata:
  name: service-server$i
spec:
  ports:
  - port: 3888
    protocol: TCP
    targetPort: 3888
  selector:
    server: "$i"
!
done
