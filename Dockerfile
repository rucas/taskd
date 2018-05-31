FROM alpine:3.4
LABEL maintainer="rucas <lucas.rondenet@gmail.com>"

ENV GOSU_VERSION 1.10
ENV TASKDDATA /var/taskd

RUN addgroup -S taskd \
  && adduser -S -G taskd taskd \
  && mkdir -p "$TASKDDATA" \
  && chown -R taskd:taskd "$TASKDDATA"

RUN apk add --no-cache \
  taskd=1.1.0-r2 \
  taskd-pki=1.1.0-r2 \
&& rm -rf /var/cache/apk/*

RUN set -x \
    && apk add --no-cache --virtual gosu-deps \
       dpkg=1.18.7-r0 \
       gnupg=2.1.12-r0 \
       openssl=1.0.2n-r0 \
    && dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
    && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc" \
    && scratch="$(mktemp -d)" \
    && export GNUPGHOME=$scratch \
    && GPG_KEYS=B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && ( gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$GPG_KEYS" \
    || gpg --keyserver pgp.mit.edu --recv-keys "$GPG_KEYS" \
    || gpg --keyserver keyserver.pgp.com --recv-keys "$GPG_KEYS" ) \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true \
    && apk del gosu-deps

VOLUME ${TASKDDATA}
WORKDIR ${TASKDDATA}

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 53589
CMD ["taskd", "server"]
