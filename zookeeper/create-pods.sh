for i in 1 2 3; do
cat <<! | oc create -f -
apiVersion: v1
kind: Pod
metadata:
  name: zookeeper-pod-$i
  labels:                                
    name: zookeeper-ensemble
    server: "$i"
spec:
  containers:                            
    - env:                                 
      - name: MYID
        value: "$i"
      name: zookeeper-pod-$i
      image: "${REG}/myproject/zookeeper"
      ports:
      - containerPort: 2888
      - containerPort: 2181
      - containerPort: 3888
!
done
