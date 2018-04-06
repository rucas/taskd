FROM alpine:3.4
LABEL maintainer="lucas.rondenet@gmail.com"
ENV TASKDDATA /var/taskd

RUN addgroup -S taskd \
  && adduser -S -G taskd taskd \
  && mkdir -p "$TASKDDATA" \
  && chown -R taskd:taskd "$TASKDDATA"

RUN apk add --no-cache \
  taskd=1.1.0-r2 \
  taskd-pki=1.1.0-r2 \
&& rm -rf /var/cache/apk/*

VOLUME "$TASKDDATA"
WORKDIR "$TASKDDATA"

RUN taskd init
