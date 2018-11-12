# Varnish Container

This provides a Docker Container for the Varnish Cache server. It can be configured using environment variables and a template

## Usage

Example:
```sh
docker run openstax/varnish:latest -T 127.0.0.1:6082
```

## Extending

To provide custom configuration for Varnish (i.e. Varnish VCL) we use [confd](http://www.confd.io/) to write the configuration file at runtime.

Create a [TOML](https://github.com/mojombo/toml) config file under `/etc/confd/conf.d/` to register a confd template.

### Example

`/etc/confd/conf.d/varnish.toml`:

```toml
[template]
src = "default.vcl.tmpl"
dest = "/etc/varnish/default.vcl"
keys = [
    "/app/api/host",
    "/app/api/port",
]
```

`/etc/confd/templates/default.vcl.tmpl`:

```vcl
# Marker to tell the VCL compiler that this VCL has been adapted to the
# new 4.0 format.
vcl 4.0;

# Default backend definition. Set this to point to your content server.
backend default {
    .host = "{{ getv "/app/api/host" }}";
    .port = "{{ getv "/app/api/port" "8080" }}";
}

sub vcl_recv {
}

sub vcl_backend_response {
}

sub vcl_deliver {
}
```

## Copyright

This software is subject to the provisions of the GNU Affero General Public License Version 3.0 (AGPL). See license.txt for details. Copyright (c) 2018 Rice University
