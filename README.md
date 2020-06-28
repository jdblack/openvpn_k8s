
# Openvpn-k8s

This code is intended for setting up an OpenVPN server for connecting to the
underlying network that your k8s cluster resides in. This container does -not-
give inherent access to any pods; for that you will need to set up load 
balancers. 

One of the primary goals of this image is to be friendly to K8s services such
as certificate manager. With that in mind, this image expects a volume that
contains ca.crt, tls.cert and tls.key that matches the format of both K8s 
secrets and cert-manager emitted secrets. 

## Installation

examples/ includes an example of how I stand this container up in K8s. I have
set up OpenWRT to port forward connections TCP:1194 to the Load Balancer for
my openvpn server.


## Recommended Tools/Additions

kubernetes - Some sort of orchestration tool is useful with this container, as
you have to manage certificates, deployments, and other related issues

certificate manager - https://github.com/jetstack/cert-manager is a great tool
for this, as it can make self-signed certificates that OpenVPN likes. This
stack is built with the assumption that you are running a self-signed CA with
cert manager (https://cert-manager.io/docs/configuration/ca/ ), though there is
no obligation to do so.


## Usage

The container has two main requirements; a volume with certs, and env variables
to configure openvpn. The volume should contain ca.cert, tls.cert and tls.key
and be mounted under /etc/openvpn.certs.  The image should also be configured
with the following environment variables:

DNS\_SERVER : The IP of the DNS server to forward to vpn clients

LOCAL\_NET : The underlying _host_ network that you wish openvpn clients to get
access to. In simpler words, the network that you would plug your laptop into.

LOCAL\_MASK : the dotted quad subnet mask for local\_net. e.g. 255.255.255.0

VPN\_NET : The tunnel network to build for openvpn. This should be unused RFC1918 address space (e.g. 192.168.x.0)

VPN\_MASK : The subnet mask for vpn\_net

ENABLE\_NAT : Whether to enable nat to the local cluster. I can't imagine a use
for turning this off, but let me know if you come up with a good use.

Please see the examples/ directory for a working example of how I stand this up
in my k8s cluster. 

## Todo

- Explain how to use cert man to make client certs.

## Caveats

This image relies upon the NET\_ADMIN capability, as it needs to be able to
set up tunneling and NAT.

## Contributing

Contributions are welcome!

## Attribution

This work was made possible by concepts that were illustrated from the
following sources:

Jerome Petazzoni: https://github.com/jpetazzo/dockvpn
Kyle Manna: https://github.com/kylemanna/docker-openvpn
Chepurko: https://github.com/chepurko/k8s-ovpn

## Gotchas

Many! :)  The odds are good that most of your problems will be related to SSL
related issues. Here are some things to watch out for:

- CA Certificates should have an expiration of under 825 days! It's tempting to
  make a CA that expires 20 years from now, but most things that use SSL certs
  will vomit all over a CA cert that has a duration of 825 days. You can see
  https://www.ssl.com/blogs/ssl-certificate-maximum-duration-825-days/ for
  details
- Client certs should expire before the CA cert expires! This is obvious when
  you think about it, but it gets all of us at some point or another.

## License
[MIT] (https://choosealicense.com/licenses/mit/)

