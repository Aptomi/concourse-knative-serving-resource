FROM mexisme/jsonnet:debian as jsonnet
FROM zlabjp/kubernetes-resource:1.13
COPY --from=jsonnet /jsonnet /usr/bin
RUN mkdir -p /opt/resource/templates
COPY templates/ /opt/templates
#COPY assets/out /opt/resource/out
