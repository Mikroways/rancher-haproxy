#!/usr/bin/env bash

set -e

function log {
    echo `date` $ME - $@
}

function checkrancher {
    log "checking rancher network..."
    a="`ip a s dev eth0 &> /dev/null; echo $?`" 
    while  [ $a -eq 1 ];
    do
        a="`ip a s dev eth0 &> /dev/null; echo $?`" 
        sleep 1
    done

    b="`ping -c 1 rancher-metadata &> /dev/null; echo $?`"
    while [ $b -eq 1 ]; 
    do
        b="`ping -c 1 rancher-metadata &> /dev/null; echo $?`"
        sleep 1 
    done
}

CONFD_BACKEND=${CONFD_BACKEND:-"zookeeper"}
CONFD_BACKEND_SERVER=${CONFD_BACKEND_SERVER:-"zookeeper:2181"}
CONFD_PREFIX=${CONFD_PREFIX:-"/"}
CONFD_INTERVAL=${CONFD_INTERVAL:-5}
CONFD_PARAMS=${CONFD_PARAMS:-"-backend ${CONFD_BACKEND} -prefix ${CONFD_PREFIX} -node ${CONFD_BACKEND_SERVER}"}
CONFD_ONETIME="/usr/bin/confd -onetime ${CONFD_PARAMS}"
CONFD_SCRIPT=${CONFD_SCRIPT:-"/usr/bin/confd-start.sh"}

CONFD_PARAMS="-interval ${CONFD_INTERVAL} ${CONFD_PARAMS}"

export CONFD_BACKEND CONFD_BACKEND_SERVER CONFD_PREFIX CONFD_INTERVAL CONFD_PARAMS 
   
checkrancher

# Create confd start script
echo "#!/usr/bin/env sh" > ${CONFD_SCRIPT}
echo "/usr/bin/nohup /usr/bin/confd ${CONFD_PARAMS} > /opt/vamp/confd.log 2>&1 &" >> ${CONFD_SCRIPT}
echo "rc=\$?" >> ${CONFD_SCRIPT}
echo "echo \$rc" >> ${CONFD_SCRIPT}
chmod 755 ${CONFD_SCRIPT}

# Run confd to get first appli configuration
log "[ Getting haproxy configuration... ]"
${CONFD_ONETIME}

# Run monit
log "[ Starting monit... ]"
/usr/bin/monit -I
