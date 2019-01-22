FROM golang:stretch as confd

ARG CONFD_VERSION=0.16.0

ADD https://github.com/kelseyhightower/confd/archive/v${CONFD_VERSION}.tar.gz /tmp/

RUN set -x \
    && mkdir -p /go/src/github.com/kelseyhightower/confd \
    && cd /go/src/github.com/kelseyhightower/confd \
    && tar --strip-components=1 -zxf /tmp/v${CONFD_VERSION}.tar.gz \
    && go install github.com/kelseyhightower/confd \
    && rm -rf /tmp/v${CONFD_VERSION}.tar.gz \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

FROM debian:stretch-slim as target

COPY --from=confd /go/bin/confd /usr/local/bin/confd
RUN mkdir -p /etc/confd/conf.d/

# Install System Dependencies
RUN set -x \
    && apt-get update \
    && apt-get install httpie -y \
    && apt-get install varnish --no-install-recommends -y \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY docker-entrypoint.sh /usr/local/bin/
COPY docker-healthcheck.sh /usr/local/bin/

ENV VARNISH_DAEMON_OPTS=""
ENV VARNISH_LOG_OPTS=""

HEALTHCHECK --interval=30s --timeout=3s --retries=1 CMD ["docker-healthcheck.sh"]

ENTRYPOINT ["docker-entrypoint.sh"]
