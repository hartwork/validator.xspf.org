# Copyright (C) 2018 Sebastian Pipping <sebastian@pipping.org>
# Licensed under GNU Affero GPL v3 or later

# Base image
FROM debian:bullseye-slim

# Start off with the most updated image possible
RUN apt-get update && apt-get --yes dist-upgrade

# Install dependencies
RUN apt-get update && apt-get install --no-install-recommends --yes -V \
        lighttpd python2.7 ca-certificates

# Install app
COPY check.py xspflogo-1.5.gif  /var/www/html/

# Activate CGI, configure URL rewrites
COPY lighttpd-*.conf  /etc/lighttpd/conf-enabled/

# Activate access log
# https://github.com/moby/moby/issues/6880#issuecomment-344114520
RUN ln -s ../conf-available/10-accesslog.conf /etc/lighttpd/conf-enabled/
RUN mkfifo -m 600 /var/log/lighttpd/access.log
RUN chown www-data:www-data /var/log/lighttpd/access.log
CMD ["sh", "-c", "cat <> /var/log/lighttpd/access.log & lighttpd -D -f /etc/lighttpd/lighttpd.conf"]

# Interface to the outside world
EXPOSE 80
