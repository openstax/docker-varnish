FROM debian:stretch-slim as target

# Install System Dependencies
RUN set -x \
    && apt-get update \
    && apt-get install httpie -y \
    && apt-get install varnish --no-install-recommends -y \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]
