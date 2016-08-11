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
  * **io.rancher_haproxy.force_ssl.<FQDN>:**: force specific domain to use ssl.
    Set this label to **true**

### Sample stack that will be proxied:

```yml
nginx:
  labels:
    io.rancher_haproxy.exposed_port: 80
    io.rancher_haproxy.server_names: example.net,www.example.net
    io.rancher_haproxy.force_ssl.www.example.net: true
  image: nginx
```

The above example will configure a reverse proxy:

* Accept connections to http://example.net and http://www.example.net
* Connections on http://www.example.net will be redirected to use https

## Runing the load balancer

A sample docker-compose.yml considering SSL support will be:

```yml
lb:
  ports:
  - 80:80/tcp
  labels:
    io.rancher.scheduler.global: 'true'
    io.rancher.container.pull_image: always
  tty: true
  image: mikroways/rancher-haproxy:1.1.0
  stdin_open: true
ssl:
  ports:
  - 443:80
  labels:
    io.rancher.loadbalancer.ssl.ports: '443'
  tty: true
  image: rancher/load-balancer-service
  links:
  - lb:lb
  stdin_open: true
```

You must configure a default rancher load balancer that only accept connections
over SSL and redirects them to lb
