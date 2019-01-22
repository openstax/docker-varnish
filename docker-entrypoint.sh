#!/usr/bin/env bash
set -Eeuo pipefail

# This file is modeled from https://github.com/docker-library/postgres/blob/3f585c58df93e93b730c09a13e8904b96fa20c58/docker-entrypoint.sh

# TODO: Assign the varnish secret at runtime

confd -onetime -backend env
printf '=%.0s' {1..80}
echo
echo 'varnish configuration complete; ready for start up.'
echo

# Start the daemon in the background. Note, docker-healthcheck.sh
# keeps an eye on this process and reports health.
varnishd -j unix,user=vcache -a :${VARNISH_PORT:-80} -f /etc/varnish/default.vcl -S /etc/varnish/secret -s malloc,${VARNISH_MALLOC:-256m} -n default ${VARNISH_DAEMON_OPTS}
# Using 'exec' allows for ^C and stop signaling without needing to do
# a hard kill via the docker engine.
exec varnishlog -n default ${VARNISH_LOG_OPTS}
