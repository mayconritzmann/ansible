# Ansible-Alpine | Maycon Ritzmann

Minimal [Alpine Linux](https://alpinelinux.org/) image for running [Ansible](https://www.ansible.com/) using only Python3.

## Build Image

### Build from git repository

```bash
$ git clone https://github.com/mayconritzmann/ansible-alpine.git && cd ansible-alpine
make build
```

The image will be tagged with the short hash from the latest git commit, e.g. `mayconritzmann/ansible-alpine:7e4e631`

### Pull from Docker Hub

```bash
docker pull mayconritzmann/ansible-alpine:latest
```

Docker Hub images will be tagged as `mayconritzmann/ansible-alpine:latest` and/or with git tags, e.g. `mayconritzmann/ansible-alpine:v0.1`

## Run container

Run a playbook inside the container:

```bash
$ docker run -it --rm \
    -v ${PWD}:/ansible \
    mayconritzmann/ansible-alpine \
    ansible-playbook -i inventory playbook.yml
```

### Builtin test for `ansible --version`

```bash
$ docker run -it --rm mayconritzmann/ansible-alpine ansible --version
ansible 2.9.16
  config file = None
  configured module search path = ['/root/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3.6/site-packages/ansible
  executable location = /usr/bin/ansible
  python version = 3.6.9 (default, Jul 19 2020, 03:46:11) [GCC 8.3.0]
```

### Builtin test for `ansible -m setup all` (localhost)

```bash
$ docker run -it --rm mayconritzmann/ansible-alpine ansible -m setup all
localhost | SUCCESS => {
    "ansible_facts": {
        "ansible_all_ipv4_addresses": [],
        "ansible_all_ipv6_addresses": [],
        "ansible_apparmor": {
            "status": "disabled"
        },
        "ansible_architecture": "x86_64",
...
```

## Shell access

```bash
$ docker run -it --rm mayconritzmann/ansible-alpine
/ansible $ whoami
root
```

## Make

Makefile included for build, run, clean,...

```bash
$ make
build                          build container
build-no-cache                 build container without cache
build-ver                      build specific ansible version: make build-ver ALPINE_VERSION="3.9" ANSIBLE_VERSION="2.9.16"
clean                          remove images
help                           this help
history                        show docker history for container
inspect                        inspect container properties - pretty: 'make inspect | jq .' requires jq
logs                           show docker logs for container (ONLY possible while container is running)
run                            run container
```
