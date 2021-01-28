FROM alpine:3.9

ARG ANSIBLE_VERSION="2.9.16"
ENV ANSIBLE_GATHERING smart
ENV ANSIBLE_HOST_KEY_CHECKING False
ENV ANSIBLE_RETRY_FILES_ENABLED False
ENV ANSIBLE_SSH_PIPELINING True

ENV BUILD_PACKAGES \
  bash \
  curl \
  tar \
  openssh-client \
  sshpass \
  git \
	htop \
	python3 \
  py-boto \
  py-setuptools \
  py-dateutil \
  py-httplib2 \
  py-jinja2 \
  py-paramiko \
	py-netaddr \
  dumb-init \
  su-exec \
  py-yaml \
  tar \
  ca-certificates

RUN set -euxo pipefail ;\
    echo "==> Setting default apk packages..."  ;\
    apk add --no-cache --update --virtual .build-deps g++ python3-dev build-base libffi-dev openssl-dev ;\
    apk add --no-cache --update ${BUILD_PACKAGES} ;\
    if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi ;\
    echo "==> Install pip..." ;\
    python3 -m ensurepip ;\
    rm -r /usr/lib/python*/ensurepip ;\
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi ;\
    pip3 install --no-cache --upgrade pip ;\
    pip3 install --no-cache --upgrade setuptools zabbix-api wheel ;\
    echo "===> Installing Ansible..." ;\
    pip install --no-cache --upgrade ansible==${ANSIBLE_VERSION} ;\
    echo "==> Adding Default Folders..." ;\
    mkdir -p /ansible /etc/ansible/ ~/.ssh ;\
    echo "===> Setting Default Configurations..." ;\
    /bin/echo -e "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts ;\
    echo "Host *" > ~/.ssh/config && echo " StrictHostKeyChecking no" >> ~/.ssh/config ;\
    echo "===> Changing sysctl parameters..." ;\
	  sysctl net.ipv4.ip_forward ;\
    echo "===> Cleaning up and set permissions..." ;\
    apk del --no-cache --purge .build-deps ;\
    rm -rf /root/.cache ;\
    rm -rf /var/cache/apk/*

WORKDIR /ansible

CMD ["/bin/bash"]