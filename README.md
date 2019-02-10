# docker-wireguard
Simple wireguard client container on top of Ubuntu (loosely based on a wireguard server container found [here](https://git.darknebu.la/maride/docker-wireguard))

## Usage

The container needs to be privileged (`--privileged`) or at least add capabilities to create network routes (NET_ADMIN) and load the wireguard module (SYS_MODULE) (`--cap-add`).

Basic usage: `docker run -e NAMESERVER="SOME_DNS_SERVER" -e INTERFACE=wg0 -v wireguard docker-wireguard`
This is the simplest way to run the container. It expects a directory (in this case named wireguard) containing wireguard configuration files

### Plain Docker

It's possible to use this container as the network namespace for another container by using `--network="container:wireguard"'` where wireguard refers to the name given to this docker-wireguard container (or even the container id).

### Kubernetes

When using k8s it's possible to VPN all traffic for a pod using this container:

1. The kubelet must be started with: `--allowed-unsafe-sysctls 'net.ipv4.conf.all.rp_filter'`
2. Merge the following with your pod's spec (adapt the NAMESERVER variable, pod CIDR and add a volume mount for the config files):
~~~~
metadata:
 annotations:
   security.alpha.kubernetes.io/unsafe-sysctls: net.ipv4.conf.all.rp_filter=2
spec:
  securityContext:
    sysctls:
    - name: net.ipv4.conf.all.rp_filter
      value: "2"
  initContainers:
  - name: route
    image: rcorrear/wireguard
    command: ["ip"]
    args: ["route", "add", "10.233.0.0/16", "dev", "eth0"]
    securityContext:
      capabilities:
        add:
          - NET_ADMIN
  containers:
  - image: rcorrear/wireguard
    name: wireguard
    env:
    - name: NAMESERVER
      value: "nameserver 193.138.219.228"
    resources:
    securityContext:
      capabilities:
        add:
          - NET_ADMIN
          - SYS_MODULE
    volumeMounts:
    - name: modules
      mountPath: /lib/modules
    - name: wireguard
      mountPath: /etc/wireguard
~~~~


## Environment variables

| Name | Required | Explanation | Default | Example
| --- | --- | --- | --- | --- |
| INTERFACE | Yes | An interface name matching a configuration file | | `wg0` |
| NAMESERVER | No | A dns server | | `1.1.1.1` |
