# Dynamic HA-Proxy based on rancher metadata

This image starts an ha-proxy that reads rancher-metadata so it autoconfigures a
default load balancer based on labels on other stacks.

The idea is forked from https://github.com/rawmind0/rancher-vamp-haproxy

## How it works

* Create your custom stack as usual
* Add labels to those containers to be proxied. You need to define two labels:
  * **io.rancher_haproxy.exposed_port**: port number to be proxied. This is
    where your internal service is listening
  * **io.rancher_haproxy.server_names**: dns domain names for this service. More
    than one DNS domain name must be separated with comma

### Sample stack that will be proxied:

```yml
nginx:
  labels:
    io.rancher_haproxy.exposed_port: '80'
    io.rancher_haproxy.server_names: example.net,www.example.net
  image: nginx
```

## Runing the load balancer

TODO

