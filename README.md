# Docker Image Resource

Tracks and serving [knative](https://cloud.google.com/knative/) applications.

Note: knative must be installed in kubernetes.

## Source Configuration

* `repository`: *Required.* The name of the repository, e.g.
`user/knative-application`.

  Note: When configuring a private registry **using a non-root CA**,
  you must include the port (e.g. :443 or :5000) even though the docker CLI
  does not require it.

* `tag`: *Optional.* The tag to track. Defaults to `latest`.

### `check`:

Do nothing.

### `in`:

Do nothing.

### `out`: Push an image, or build and push a `Dockerfile`.

Push a Docker image to the source's repository and tag. The resulting
version is the image's digest.

#### Parameters

* `app_name`: *Optional.* Knative app name

* `image`: *Required.* The name and tag of the repository, e.g. aptomi/rest-api:latest

* `namespace`: *Required.* The kubernetes namespace

  example:
  ```yaml
  params:
    app_name: rest-api:latest
    image: aptomi/rest-api
    namespace: applaction
  ```

## Example

```
jobs:
  - name: rest-api
  ¦ plan:
  ¦ ¦ - get: docker-image
  ¦ ¦ ¦ trigger: true
  ¦ ¦ - params:
  ¦ ¦ ¦ ¦ kubectl: cluster-info
  ¦ ¦ ¦ ¦ app_name: rest-api
  ¦ ¦ ¦ ¦ image: aptomi/rest-api
  ¦ ¦ ¦ ¦ namespace: default
  ¦ ¦ ¦ put: knative-serving

resource_types:
  - name: knative-serving
  ¦ source:
  ¦ ¦ repository: aptomisvc/concourse-knative-serving-resource
  ¦ ¦ tag: latest
  ¦ type: docker-image
```



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
      repository: aptomisvc/concourse-knative-resource
      tag: latest
    type: docker-image

resources:
  - name: knative
    source:
      kubeconfig: ((kubeconfig))
    type: knative
```
