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
```YAML
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
  className: "nginx"
  host: my-domain.com
  annotations:
    kubernetes.io/tls-acme: "true"

persistence:
  enabled: true
  size: 1Gi
```

You can also change the Apache configuration, if necessary, by downloading the default
[values.yaml](https://raw.githubusercontent.com/danuk/k8s-webdav/master/k8s-webdav/values.yaml)
and changing it.

### Use existing k8s secret for authentication:

Existing htpasswd secret stored within the same namespace can be used.

Example:
```YAML
urls:
  /:
    htpasswdSecretRef:
      name: htpasswd
      key: root

existingHtpasswdSecrets:
  - name: htpasswd
```

The htpasswd secret shall be created in advance. The `htpasswd` tool can be used to generate the secret.

First generate the htpasswd content for the user(s):

```shell
$ htpasswd -n -b user password
user:$apr1$DRUWLwA4$bG9RXXF1XAAF1dCIIoX/H1
```

Create a secret from it and apply on the cluster before installing the helm release.

#### `htpasswd-secret.yaml`:
```YAML
apiVersion: v1
kind: Secret
metadata:
  name: htpasswd
type: Opaque
stringData:
  root: |
    user:$apr1$DRUWLwA4$bG9RXXF1XAAF1dCIIoX/H1
```

Add multiple lines to the secret data value to add more user authentications and add more secret data keys to create multiple user authentication sets to refer.

Apply it:
```shell
kubectl apply -f htpasswd-secret.yaml
```

### Use HostPath persistency

HostPath can be configured for the persistency type, which mounts a directory from the host.

```YAML
persistence:
  enabled: true
  type: hostPath
  hostPath: /path/on/host
```

In this case, it is the user's responsibility to grant permission to the UID:33 GID:33 (www-data) user to manage this directory.

### Deploy the WebDav server to Kubernetes:
```
helm repo add k8s-webdav https://danuk.github.io/k8s-webdav/
helm upgrade -i my-webdav k8s-webdav/webdav -f values.yaml
```
