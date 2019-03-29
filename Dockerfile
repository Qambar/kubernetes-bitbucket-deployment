FROM ubuntu:16.04

ENV NAMESERVER=
ENV DEBIAN_FRONTEND noninteractive
ENV INTERFACE wg0

# Copy-Pasta from https://www.wireguard.com/install/
RUN echo "resolvconf resolvconf/linkify-resolvconf boolean false" | debconf-set-selections
RUN echo "deb http://deb.debian.org/debian/ unstable main" > /etc/apt/sources.list.d/unstable-wireguard.list
RUN printf 'Package: *\nPin: release a=unstable\nPin-Priority: 150\n' > /etc/apt/preferences.d/limit-unstable
RUN apt-get update && apt-get install -y gnupg
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 04EE7237B7D453EC
RUN apt-get update
RUN apt-get install -y --allow-unauthenticated iproute2 wireguard-dkms wireguard-tools resolvconf

COPY run.sh /run.sh

CMD /run.sh

#
# Setup dependencies.
#
RUN mkdir -p ~/bin
RUN cd ~/bin
RUN export PATH="$PATH:/root/bin"
RUN apt-get update -y
RUN apt-get install -y software-properties-common unzip python-pip jq wget curl openssh-client

# Dependency: Terraform.
RUN wget https://releases.hashicorp.com/terraform/0.11.13/terraform_0.11.13_linux_amd64.zip
RUN unzip terraform_0.11.13_linux_amd64.zip
RUN mv terraform /usr/local/bin/
RUN terraform --version

# Dependency: kubectl.
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv kubectl /usr/local/bin/
RUN kubectl
