FROM debian:stretch-slim as target

# Install System Dependencies
RUN set -x \
    && apt-get update \
    && apt-get install httpie -y \
    && apt-get install varnish --no-install-recommends -y \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY varnish.vcl /etc/varnish/varnish.vcl.template
COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]

#CMD ["varnishd", "-a", ":80", "-f", "/etc/varnish/default.vcl", "-S", "/etc/varnish/secret",
#    "-s", "malloc,256m", "-p", "pipe_timeout=1200", "-p vcc_allow_inline_c=on"]
