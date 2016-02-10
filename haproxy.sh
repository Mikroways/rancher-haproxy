#!/usr/bin/env bash

case "$1" in
        "start")
            haproxy -f /opt/vamp/haproxy.cfg -p /opt/vamp/haproxy.pid -sf $(cat /opt/vamp/haproxy.pid)
        ;;
        "restart")
            haproxy -f /opt/vamp/haproxy.cfg -p /opt/vamp/haproxy.pid -sf $(cat /opt/vamp/haproxy.pid)
        ;;
        "stop")
            kill -15 $(cat /opt/vamp/haproxy.pid)
        ;;
        *) echo "Usage: $0 start|stop"
        ;;

esac
