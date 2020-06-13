* Run in local
DIR /go-app
- go run main.go

* Run on a kubernetes cluster
kubectl apply -f development.yml
kubectl apply -f service.yml
kubectl get pods
kubectl get services

