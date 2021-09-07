# WebDav server
WebDav server based on Apache.

The Apache server supports the WebDav protocol better than Nginx, which is especially important for Windows.

This chart uses only the official Apache docker image (httpd), and you don't need to build your own image.
All the configuration files make by helm on the installation.

It has been tested on Linux and Windows.

# Setup Instructions

This chart only works with helm3, because of `htpasswd` function has been available since helm3.

## Deployment
To deploy to Kubernetes follow these steps:

### Create `values.yaml` file like this:
```
urls:
  /:
  - user: user1
    password: password1
  - user: user2
    password: password2
  /foo:
  - user: user3
    password: password3

ingress:
  host: my-domain.com
  annotations:
    kubernetes.io/ingress.class: nginx
    kubernetes.io/tls-acme: "true"

persistence:
  enabled: true
  size: 1Gi
```

You can also change the Apache configuration, if necessary, by downloading the default
[values.yaml](https://raw.githubusercontent.com/danuk/k8s-webdav/master/k8s-webdav/values.yaml)
and changing it.

### Deploy the WebDav server to Kubernetes:
```
helm repo add k8s-webdav https://danuk.github.io/k8s-webdav/
helm upgrade -i k8s-webdav k8s-webdav/k8s-webdav -f values.yaml
```


