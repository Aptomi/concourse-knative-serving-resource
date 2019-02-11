{
	"docker": {
		apiVersion: "v1",
		kind: "Secret",
		metadata: {
  		name: "{{ p.auth_name }}",
  		annotations: {
  			"build.knative.dev/docker-0": "https://index.docker.io/v1/"
			},
		},
		type: "kubernetes.io/basic-auth",
		data: {
  		username: "{{ p.dockerhub.username | b64encode }}",
  		password: "{{ p.dockerhub.password | b64encode }}",
		}
	},

	"service-secret": {
		apiVersion: "v1",
		kind: "ServiceAccount",
		metadata: {
  		name: "build-bot",
		},
		secrets: [
			{
  			name: "{{ p.auth_name }}",
			},
		],
	},

	service: {
	"apiVersion": "serving.knative.dev/v1alpha1",
	"kind": "Service",
	"metadata": {
		"name": "{{ p.app_name }}",
		"namespace": "default"
	},
	"spec": {
		"runLatest": {
			"configuration": {
				"build": {
					"apiVersion": "build.knative.dev/v1alpha1",
					"kind": "Build",
					"spec": {
						"serviceAccountName": "build-bot",
						"source": {
							"git": {
								"url": "{{ p.repo }}",
								"revision": "master"
							}
						},
						"template": {
							"name": "kaniko",
							"arguments": [
								{
									"name": "IMAGE",
									"value": "docker.io/{{ p.dockerhub.username }}/app-from-source:latest"
								}
							]
						}
					}
				},
				"revisionTemplate": {
					"spec": {
						"container": {
							"image": "docker.io/{{ p.dockerhub.username }}/app-from-source:latest",
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
