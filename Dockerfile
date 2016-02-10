FROM rawmind/rancher-base:0.0.2-1
MAINTAINER Raul Sanchez <rawmind@gmail.com>

ENV VAMP_HOME /opt/vamp
# Install haproxy
RUN set -ex && \
    apk --update add iptables iproute2 libnl3-cli musl-dev linux-headers curl gcc pcre-dev make zlib-dev && \
    mkdir /usr/src && \
    curl -fL http://www.haproxy.org/download/1.6/src/haproxy-1.6.3.tar.gz | tar xzf - -C /usr/src && \
    cd /usr/src/haproxy-1.6.3 && \
    make TARGET=linux2628 USE_PCRE=1 USE_ZLIB=1 && \
    make install-bin && \
    cd .. && \
    rm -rf /usr/src/haproxy-1.6.3 && \
    apk del musl-dev linux-headers curl gcc pcre-dev make zlib-dev && \
    apk add musl pcre zlib && \
    rm /var/cache/apk/*

# Add confd tmpl and toml
ADD confd/*.toml /etc/confd/conf.d/
ADD confd/*.tmpl /etc/confd/templates/

# Add monit conf for services
ADD monit/*.conf /etc/monit/conf.d/

# Add start.sh
ADD start.sh /usr/bin/
ADD haproxy.sh /usr/bin/
RUN chmod +x /usr/bin/*.sh 

WORKDIR ${VAMP_HOME}

ENTRYPOINT ["/usr/bin/start.sh"]
