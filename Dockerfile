FROM mexisme/jsonnet:debian as jsonnet
FROM zlabjp/kubernetes-resource:1.13
ENV JSONNET_TEMPLATE="/opt/resource/knative.jsonnet"
ENV RENDER_DIR="/opt/resource/rendered"
RUN mkdir -p ${RENDER_DIR}

RUN apt update && apt install -y gnupg2 && \
    export CLOUD_SDK_REPO="cloud-sdk-sid" && \
    echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update -y && apt-get install google-cloud-sdk -y


COPY --from=jsonnet /jsonnet /usr/bin
COPY templates/knative-serving.jsonnet ${JSONNET_TEMPLATE}
COPY assets/out /opt/resource/out
