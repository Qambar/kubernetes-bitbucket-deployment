FROM ubuntu:latest

ENV NAMESERVER=
ENV DEBIAN_FRONTEND noninteractive
ENV INTERFACE wg0

# Copy-Pasta from https://www.wireguard.com/install/
RUN echo "resolvconf resolvconf/linkify-resolvconf boolean false" | debconf-set-selections
RUN echo "deb http://deb.debian.org/debian/ unstable main" > /etc/apt/sources.list.d/unstable-wireguard.list
RUN printf 'Package: *\nPin: release a=unstable\nPin-Priority: 150\n' > /etc/apt/preferences.d/limit-unstable
RUN apt-get update
RUN apt-get install -y --allow-unauthenticated iproute2 wireguard-dkms wireguard-tools resolvconf

COPY run.sh /run.sh

CMD /run.sh
