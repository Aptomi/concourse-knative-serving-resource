```
$ kubectl apply --filename https://github.com/knative/serving/releases/download/v0.4.0/istio-crds.yaml && \
$ kubectl apply --filename https://github.com/knative/serving/releases/download/v0.4.0/istio.yaml

$ kubectl label namespace default istio-injection=enabled
```

```
$ kubectl apply --filename https://github.com/knative/serving/releases/download/v0.4.0/serving.yaml \
--filename https://github.com/knative/build/releases/download/v0.4.0/build.yaml \
--filename https://github.com/knative/eventing/releases/download/v0.4.0/release.yaml \
--filename https://github.com/knative/eventing-sources/releases/download/v0.4.0/release.yaml \
--filename https://github.com/knative/serving/releases/download/v0.4.0/monitoring.yaml \
--filename https://raw.githubusercontent.com/knative/serving/v0.4.0/third_party/config/build/clusterrole.yaml
```


```
$ curl -LO https://github.com/Aptomi/concourse-pipelines/blob/master/knative-serving/01_knative_serving_pipeline.yml
```
```
$ fly -t concourse login -u https://concourse
```
```
$ fly -t concourse set-pipeline -p knative-serving-example -c ./01_knative_serving_pipeline.yml
$ fly -t concourse unpause-pipeline -p knative-serving-example
```

```
$ kubectl -n default get ksvc
NAME                    DOMAIN                                      LATESTCREATED                 LATESTREADY                   READY   REASON
rest-api                rest-api.default.example.com                rest-api-00001                rest-api-00001                True
```

```
$ kubectl get configuration,service,route,revision,deployment -l "serving.knative.dev/service=rest-api"

NAME                                         LATESTCREATED    LATESTREADY      READY   REASON
configuration.serving.knative.dev/rest-api   rest-api-00001   rest-api-00001   True

NAME                             TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)           AGE
service/rest-api-00001-service   ClusterIP   10.11.248.6   <none>        80/TCP,9090/TCP   2m

NAME                                 DOMAIN                         READY   REASON
route.serving.knative.dev/rest-api   rest-api.default.example.com   True

NAME                                          SERVICE NAME             AGE   READY   REASON
revision.serving.knative.dev/rest-api-00001   rest-api-00001-service   2m    True

NAME                                              DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
deployment.extensions/rest-api-00001-deployment   0         0         0            0           2m
```

```
$ INGRESSGATEWAY=istio-ingressgateway
$ INGRESSGATEWAY_LABEL=istio

$ export INGRESS_IP=`kubectl get svc $INGRESSGATEWAY --namespace istio-system --output jsonpath="{.status.loadBalancer.ingress[*].ip}"`
$ export SERVICE_HOSTNAME=`kubectl get ksvc rest-api --output jsonpath="{.status.domain}"`
```

```
$ kubectl get pods -l app=rest-api-00001
NAME                                        READY   STATUS    RESTARTS   AGE
```

```
$ time curl --header "Host:$SERVICE_HOSTNAME" http://${INGRESS_IP}
Welcome to the stock app!

real    0m8,122s
user    0m0,008s
sys     0m0,023s
```

```
$ kubectl get pods -l app=rest-api-00001
NAME                                        READY   STATUS    RESTARTS   AGE
rest-api-00001-deployment-99c8c558d-45fs8   3/3     Running   0          1m
```


```
$ time curl --header "Host:$SERVICE_HOSTNAME" http://${INGRESS_IP}
Welcome to the stock app!

real    0m0,950s
user    0m0,024s
sys     0m0,014s
```

```
$ hey -z 30s -c 50 -host $SERVICE_HOST NAME http://${INGRESS_IP}

Summary:
  Total:        30.1948 secs
  Slowest:      0.4106 secs
  Fastest:      0.1605 secs
  Average:      0.1830 secs
  Requests/sec: 272.0337

  Total data:   221778 bytes
  Size/request: 27 bytes

Response time histogram:
  0.161 [1]     |
  0.186 [5933]  |■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
  0.211 [1756]  |■■■■■■■■■■■■
  0.236 [327]   |■■
  0.261 [96]    |■
  0.286 [31]    |
  0.311 [13]    |
  0.336 [8]     |
  0.361 [7]     |
  0.386 [22]    |
  0.411 [20]    |
```
