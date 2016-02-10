rancher-vamp-haproxy
==========================

vamp-gateway-agent image based in rancher-base (alpine)

To build

```
docker build -t <repo>/rancher-vamp-gateway-agent:<version> .
```

To run:

```
docker run -it <repo>/rancher-vamp-gateway-agent:<version> 
```

# How it works

* The docker has the entrypoint /usr/bin/start.sh, that check rancher-metadata server connectivity, starts confd and monit. It checks, reconfigures and reload haproxy, every $CONFD_INTERVAL seconds.
* Scale could be from 1 to n nodes. 
* Default env variables values:
CONFD_BACKEND=${CONFD_BACKEND:-"zookeeper"}
CONFD_BACKEND_SERVER=${CONFD_BACKEND_SERVER:-"zookeeper:2181"}
CONFD_PREFIX=${CONFD_PREFIX:-"/"}
CONFD_INTERVAL=${CONFD_INTERVAL:-5}
CONFD_PARAMS=${CONFD_PARAMS:-"-backend ${CONFD_BACKEND} -prefix ${CONFD_PREFIX} -node ${CONFD_BACKEND_SERVER}"}
CONFD_ONETIME="/usr/bin/confd -onetime ${CONFD_PARAMS}"
CONFD_SCRIPT=${CONFD_SCRIPT:-"/usr/bin/confd-start.sh"}
