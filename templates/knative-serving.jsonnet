local app_name(inv) = inv.params.app_name;

function(inv) {
	"service.json": {
      "apiVersion": "serving.knative.dev/v1alpha1",
      "kind": "Service",
      "metadata": {
        "name": app_name(inv),
        "namespace": inv.params.namespace,
      },
      "spec": {
        "runLatest": {
          "configuration": {
            "revisionTemplate": {
              "metadata": {
                "labels": {
                  "knative.dev/type": "container"
                }
              },
              "spec": {
                "container": {
                  "image": inv.params.image,
                  "env": [
                    {
                      "name": "RESOURCE",
                      "value": "stock"
                    }
                  ],
                  "readinessProbe": {
                    "httpGet": {
                      "path": "/"
                    },
                    "initialDelaySeconds": 0,
                    "periodSeconds": 3
                  }
                }
              }
            }
          }
        }
      }
	}
}
