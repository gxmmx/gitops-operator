# operator

A [Docker image](https://hub.docker.com/r/gxxmx/gitops-operator) published on Dockerhub for use in CI-CD pipelines.  
Contains useful tools for deployment and provisioning.

<br>

<!-- TABLE OF CONTENTS -->
<details>
    <summary><h2>Table of Contents</h2></summary>

* [About](#about)
* [Information](#information)
* [Usage](#usage)
* [Changes](#changes)
* [Contributing](#contributing)
* [License](#license)
* [Contact](#contact)

</details>

<br>

<!-- About -->
## About

Container image mainly for use in CICD pipelines.  
Contains [Terraform](https://www.terraform.io), [Gitlab-Terraform](https://docs.gitlab.com/ee/user/infrastructure/iac/gitlab_terraform_helpers.html), [Ansible](https://www.ansible.com) and [Cloudflare cli4](https://github.com/cloudflare/python-cloudflare)

<!-- Information -->
## Information

### Platforms
This container is made for [Gitlab-CI/CD](https://docs.gitlab.com/ee/ci/) pipelines, but is it built on multiple architectures, and can be used on platforms listed on the [Dockerhub repository](https://hub.docker.com/r/gxxmx/gitops-operator).

<br>

<!-- Usage -->
## Usage

### Standalone Docker image
The image can be used with Docker directly:

```sh
docker run --rm -it gxmmx/gitops-operator:latest sh
```

This runs a container with the formentioned tooling.

### Gitlab CI

Example `.gitlab-ci.yml` for running terraform with a Gitlab managed state.  
After deployment Ansible provisions the new infrastructure from the same image.

``` yaml
---
image:
  name: "gxmmx/gitops-operator:latest"

variables:
  TF_ROOT: ${CI_PROJECT_DIR}
  TF_STATE_NAME: statebackendname

cache:
  key: "${TF_ROOT}"
  paths:
    - ${TF_ROOT}/.terraform/

terraform fmt:
  stage: validate
  script:
    - gitlab-terraform fmt
    - gitlab-terraform validate

terraform deploy:
  stage: deploy
  script:
    - gitlab-terraform apply
  resource_group: ${TF_STATE_NAME}
  rules:
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH && $TF_AUTO_DEPLOY == "true"
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH
      when: manual

terraform destroy:
  stage: cleanup
  script:
    - gitlab-terraform destroy
  resource_group: ${TF_STATE_NAME}
  when: manual

ansible provision:
  stage: provision
  script:
    - ansible-playbook site.yml
  rules:
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH
      when: manual

```

> This example is based on [Gitlabs Terraform Base](https://gitlab.com/gitlab-org/gitlab/blob/master/lib/gitlab/ci/templates/Terraform/Base.gitlab-ci.yml).


<br>

<!-- Changes -->
## Changes

Version history with features and bugfixes, as well as upcoming features and roadmap
depicted in `CHANGELOG.md`.  

<br>

<!-- Contributing -->
## Contributing

Any contributions are greatly appreciated. See `CONTRIBUTING.md` for more information.

### Contributors

* [gummigudm](https://gitlab.com/gummigudm)  

<br>

<!-- License -->
## License

Distributed under the MIT License. See `LICENSE` for more information.

<br>

<!-- Contact -->
## Contact

Guðmundur Guðmundsson - <gummigudm@gmail.com>

* Gitlab - [gummigudm](<https://gitlab.com/gummigudm>)  
* Github - [gummigudm](<https://github.com/gummigudm>)  
