#!/bin/sh
# The shebang (`#!/bin/sh`) specifies that this script should be executed using the Bourne shell (`sh`).
# This is a common choice for lightweight and portable scripting.

set -e
# The `set -e` command ensures that the script exits immediately if any command returns a non-zero exit status.
# This helps prevent the script from continuing with unexpected errors, improving reliability.

# Use `envsubst` to replace environment variables in a template configuration file.
# `envsubst` is a tool that substitutes environment variables in a given input.
envsubst < /etc/nginx/default.conf.tpl > /etc/nginx/conf.d/default.conf
# - `/etc/nginx/default.conf.tpl` is the input file, which is a template for the NGINX configuration.
# - Any placeholders in the template (e.g., `${VARIABLE_NAME}`) are replaced with their actual environment variable values.
# - The output is written to `/etc/nginx/conf.d/default.conf`, which is the actual configuration file NGINX will use.

nginx -g 'daemon off;'
# This starts the NGINX web server with the `-g` option to specify additional configuration directives.
# The `daemon off;` directive tells NGINX to run in the foreground instead of detaching as a background process.
# Running in the foreground is typical in containerized environments (e.g., Docker) to ensure the container remains active.
