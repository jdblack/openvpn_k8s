FROM ubuntu:bionic
RUN mkdir -p /etc/openvpn/certs && \
    apt-get update -q && \
    apt-get install -qy openvpn iptables socat curl && \
    apt-get clean
ADD ./bin /usr/local/sbin
ADD ./openvpn.conf /etc/openvpn
VOLUME /etc/openvpn/certs
EXPOSE 1194/tcp
CMD run

