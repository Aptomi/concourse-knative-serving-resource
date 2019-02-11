```
jobs:

  - name: knative application
    plan:
      - params:
          kubectl: get nodes
          app_name: knative-sandboox
          repo:
            url: https://github.com/metacoma/knatve-sandboox.git
            branch: master
          dockerhub:
            username: ((dockerhub_username))
            password: ((dockerhub_password))
        put: knative

resource_types:
  - name: knative
    source:
      repository: metacoma/concourse-resource-knative
      tag: latest18
    type: docker-image

resources:
  - name: knative
    source:
      kubeconfig: ((kubeconfig))
    type: knative
```
