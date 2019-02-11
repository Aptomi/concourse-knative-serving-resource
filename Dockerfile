FROM mexisme/jsonnet:debian as jsonnet
FROM zlabjp/kubernetes-resource:1.13
ENV JSONNET_TEMPLATE="/opt/resource/knative.jsonnet"
ENV RENDER_DIR="/opt/resource/rendered"
RUN mkdir -p ${RENDER_DIR}
COPY --from=jsonnet /jsonnet /usr/bin
COPY templates/knative.jsonnet ${JSONNET_TEMPLATE}
COPY assets/out /opt/resource/out
