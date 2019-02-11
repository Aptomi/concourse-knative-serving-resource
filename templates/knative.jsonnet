local app_name_secret(inv) = inv.params.app_name + "-secret";
local service_account_name(inv) = inv.params.app_name + "-build-bot";
local image_url(inv) = "docker.io/" + inv.params.dockerhub.username + "/app-from-source:latest";

function(inv) {
	"secret.json": {
		apiVersion: "v1",
		kind: "Secret",
		metadata: {
  		name: app_name_secret(inv),
  		annotations: {
  			"build.knative.dev/docker-0": "https://index.docker.io/v1/"
			},
		},
		type: "kubernetes.io/basic-auth",
		data: {
  		username: std.base64(inv.params.dockerhub.username),
  		password: std.base64(inv.params.dockerhub.password),
		}
	},

	"service-account.json": {
		apiVersion: "v1",
		kind: "ServiceAccount",
		metadata: {
  		name: service_account_name(inv),
		},
		secrets: [
			{
  			name: app_name_secret(inv),
			},
		],
	},

	"service.json": {
  	"apiVersion": "serving.knative.dev/v1alpha1",
  	"kind": "Service",
  	"metadata": {
  		"name": inv.params.app_name,
  		"namespace": "default"
  	},
  	"spec": {
  		"runLatest": {
  			"configuration": {
  				"build": {
  					"apiVersion": "build.knative.dev/v1alpha1",
  					"kind": "Build",
  					"spec": {
  						"serviceAccountName": service_account_name(inv),
  						"source": {
  							"git": {
  								"url": inv.params.repo.url,
  								"revision": inv.params.repo.branch,
  							},
  						},
  						"template": {
  							"name": "kaniko",
  							"arguments": [
  								{
  									"name": "IMAGE",
  									"value": image_url(inv),
  								}
  							]
  						}
  					}
  				},
  				"revisionTemplate": {
  					"spec": {
  						"container": {
  							"image": image_url(inv),
  							"imagePullPolicy": "Always",
  							"env": [
  								{
  									"name": "SIMPLE_MSG",
  									"value": "Hello from the sample app!"
  								}
  							]
  						}
  					}
  				}
  			}
  		}
  	}

	}
}
