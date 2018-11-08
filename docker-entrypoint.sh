#!/usr/bin/env bash
set -Eeuo pipefail

# This file is modeled from https://github.com/docker-library/postgres/blob/3f585c58df93e93b730c09a13e8904b96fa20c58/docker-entrypoint.sh

# Start your command with '-' to extend the existing nginx startup
if [ "${1:0:1}" == '-' ]; then
    # `-j unix,user=vcache` -- jail for use by the vcache user
    # `-F` -- run in the foreground
    # `-a :80` -- listen on any address at port 80
    # `-f /etc/varnish/default.vcl` -- use the default varnish configuration
    # `-S /etc/varnish/secret` -- varnish secret
	set -- varnishd -j unix,user=vcache -F -a :${VARNISH_PORT:-80} -f /etc/varnish/default.vcl -S /etc/varnish/secret -s malloc,${VARNISH_MALLOC:-256m} $@
fi

# TODO: Assign the varnish secret at runtime

if [ "$1" = 'varnishd' ]; then

	echo
	echo "Configuring varnishd VCL from environment variables."
    printf '=%.0s' {1..80}
    echo 

    # TODO: use confd to write the conf

	echo
    printf '=%.0s' {1..80}
    echo
	echo 'varnish configuration complete; ready for start up.'
	echo
fi

echo "$@"
exec "$@"
