# Pipetools-ansible

Pipetools-Ansible - multiplatform, alpine based pipeline helper for CI/CD, with ansible

## Tools

* ca-certificates
* curl
* bash
* gettext
* tar
* gzip
* openssl
* openssh
* rsync
* python3
* python3-dev
* py3-pip
* py3-wheel
* shellcheck
* tzdata
* git
* httpie
* sshfs
* nmap

## Python 3 packages

* pip
* yamllint
* jsonlint
* dos2unix
* ansible
* ansible-lint

## Ansible collections

* ansible.posix
* ansible.windows
* ansible.utils
* chocolatey.chocolatey
* community.aws
* community.azure
* community.crypto
* community.dns
* community.docker
* community.fortios
* community.general
* community.google
* community.hashi_vault
* community.kubernetes
* community.network
* community.windows
* community.zabbix
* kubernetes.core

## Gitlab pipeline example

```yaml
stages:
  - ansible-lint
ansible-lint:
  stage: ansible-lint
  image: marcinbojko/pipetools-ansible
  services:
    - docker:20.10-dind
  before_script:
    - yamllint --version
    - ansible-lint --version
  script:
    - yamllint -c ./.yamllint ./tasks/*.yml
    - yamllint -c ./.yamllint *.yaml
    - ansible-lint -v ./tasks/*.yml
    - ansible-lint -v *.yaml
```
