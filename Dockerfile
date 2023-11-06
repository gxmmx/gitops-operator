FROM alpine:latest

## Versions
ENV TERRAFORM_VERSION 1.6.2
ENV ANSIBLE_VERSION 2.15.5
ENV RUAMEL_YAML 0.17.21

## Arguments
ARG TARGETARCH

## Install base
RUN apk add --no-cache wget ca-certificates unzip python3 py3-pip openssl bash && \
    apk add --no-cache --virtual build-dependencies python3-dev libffi-dev openssl-dev build-base
## Install gitlab deps
RUN apk add --no-cache curl gcompat git idn2-utils jq openssh
## Install Ansible deps
RUN pip install --no-cache-dir pip cffi ruamel-yaml==${RUAMEL_YAML}

## Install Ansible
RUN pip install --no-cache-dir ansible-core==${ANSIBLE_VERSION}

## Install Cloudflare
RUN pip install --no-cache-dir cloudflare

## Install Terraform
RUN wget -q -O /terraform.zip "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${TARGETARCH}.zip" && \
    unzip /terraform.zip -d /bin

## Install Gitlab Terraform
RUN wget -q -O /usr/bin/gitlab-terraform "https://gitlab.com/api/v4/projects/18943607/repository/files/src%2Fbin%2Fgitlab-terraform.sh/raw?ref=master" && \
    chmod +x /usr/bin/gitlab-terraform

## Cleanup
RUN apk del build-dependencies && \
    rm -rf /terraform.zip

ENTRYPOINT []
