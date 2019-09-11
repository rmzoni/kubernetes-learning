## Install Heapster
```sh
$ kubectl create -f https://raw.githubusercontent.com/kubernetes/kops/master/addons/monitoring-standalone/v1.11.0.yaml
```

## Config Influxdb e Grafana
```sh
$ kubectl create -f influxdb/
$ kubectl create -f heapster-rbac.yaml
```
Grafana service by default requests for a LoadBalancer. If that is not available in your cluster, consider changing that to NodePort. Use the external IP assigned to the Grafana service, to access Grafana. The default user name and password is 'admin'. Once you login to Grafana, add a datasource that is InfluxDB. The URL for InfluxDB will be http://INFLUXDB_HOST:INFLUXDB_PORT. Database name is 'k8s'. Default user name and password is 'root'. Grafana documentation for InfluxDB here.

Take a look at the storage schema to understand how metrics are stored in InfluxDB.
Grafana is set up to auto-populate nodes and pods using templates.
The Grafana web interface can also be accessed via the api-server proxy. The URL should be visible in kubectl cluster-info once the above resources are created.


1. If the Grafana service is not accessible, it might not be running. Use kubectl to verify that the heapster and influxdb & grafana pods are alive.

```
$ kubectl get pods --namespace=kube-system
...
monitoring-grafana-927606581-0tmdx        1/1       Running   0          6d
monitoring-influxdb-3276295126-joqo2      1/1       Running   0          15d
...

$ kubectl get services --namespace=kube-system monitoring-grafana monitoring-influxdb
```

2. If you find InfluxDB to be using up a lot of CPU or memory, consider placing resource restrictions on the InfluxDB & Grafana pods. You can add cpu: <millicores> and memory: <bytes> in the Controller Specs for InfluxDB and Grafana, and relaunch the controllers by running kubectl apply -f deploy/kube-config/influxdb/ and deleting the old influxdb pods.

## ElasticSearch, Fluentd and Kibana