Continuous Integration
======================

Continuous Integration (CI) is a process which defines all steps required to produce final artifact (docker image) that will be delivered and deployed eventually to PRODUCTION. While producing the docker image, various tests can be implemented to confirm that change conform company's standards and that it does not introduce new bugs.

CI is build with following requirements:

- **easiness** - least effort from developer to trigger the process
- **feedback** - provide CI statuses (can be multiple) from all tests or steps in the CI process to developer or release manager fast, before the change is delivered, so they can take informed decision about the delivery and state of the change.
- **flexibility** - per application flexibility, allows dev teams to evolve the process so it follows application evolution.
- **security** - secure enough to suffice security department
- **speed** - be as fast as possible, in order to provide the feedback to developer fast enough

During the CI implementation some assumptions are made, which are not necessary requirements and most of the time can be changed easily. Here are some of them documented, but list is not exhaustive.

- source code tags for version
- 1 to 1 relation between a GHE repo and an image
- naming conventions

Architecture
------------

Every factory is released using an AWS CodeBuild Project, which starts a docker container.

Images
------

There are several images mentioned in CI and it can be confusing which one is referred at a given moment.

Here is the complication: The image factories are started from Docker images, which produce Docker images, which are based from another Docker image. To make it even more complicated, factories can be started from custom Docker images that again are build from another factories which again use as base image different image.

Here is classification based from factory point of view

* factory runtime images - are the images that are started by AWS CodeBuild projects (image factories) and which produce the artifact image
* base images - are the images that are used in `FROM:` line in Dockerfile for the artifact image
* output images - are images that will be used by CD to deploy the application

There could be more than one image per type.

Images relations

| factory                   | runtime-image (CODEBUILD factory) | base-image (FROM: in Dockerfile) | output-image (artifact) | trigger                                                          |
| -                         | -                                 | -                                | -                       | -                                                                |
| prefix-base-amazonlinux   | standard-amazonlinux              | amazonlinux                      | base-amazonlinux        | push in repo base_amazonlinux  |
| prefix-platform-terraform | standard-amazonlinux              | base-amazonlinux                 | platform-terraform      | push in repo application_infra |
| prefix-platform-k8s       | standard-amazonlinux              | base-amazonlinux                 | platform-k8s            | push in repo k8s               |
| prefix-hs-main            | standard-amazonlinux              | base-amazonlinux                 | hs-main                 | push in repo hs-main           |
| prefix-db                 | standard-amazonlinux              | base-amazonlinux                 | db                      | push in repo db                |

There is another classification of images, that is based on their use cases:

- gold images - these are images that passed os level hardening. Usually these are either copied or copied and hardened 3rd party images (downloaded from external sources).
- platform images - these images extend gold images and add some tooling and setup. Example is to install terraform and use the image to deploy terraform code.
- application images - these images contains an application and its requirements in order to be able to start the application usually in K8S cluster.

Image types from use-case point of view

| image name        | image type        | description
| -                 | -                 | -
| prefix-image-name | gold image        | hardened amazonlinux
| prefix-image-name | platform image    | used by infra CD to deploy infrastructure (terraform)
| prefix-image-name | application image | hs-main app
| prefix-image-name | application image | used by CI process to mock the application DB in order to run some tests



Naming Conventions
------------------

There are several entities that should be able to connect and by defining naming conventions, simplifies the implementation.

Entities are:

- GHE repo name
- IaC folder name
- AWS CodeBuild Project name
- AWS ECR repo name

if prefix + GHE repo_name = AWS CodeBuild Project name
    start AWS CodeBuild Project which will push output-image to ecr repo name

Immutability
------------

CI image factories will never modify existing images. For every change that trigger the image factory, it will produce a new image, that can be used to deploy new version of an application or the infrastructure.

By itself, image factories are defined as Infrastructure as Code (terraform) and are deployed by infrastructure pipeline.

Release
-------

CI process is usually triggered on every push event in the code repository. Every push, results in status and an image, but the image is deleted at the end of the process, unless it meet certain criteria:
* push is in the master branch
* image pass all validations - number of validations and their exact order and implementation is part of the application source code and can be different per application
* version is bumped up in file .version in the top-root level of the application repository.

If an image is to be preserved, then a new tag is added - content of .version file.

Preserved images from the CI process can further pass through different decision making process that will decide if the image will be kept or deleted.

There is also a Release Process, which marks which images are to be delivered and deployed in the environments.


Flexibility
-----------

Every Image Factory in the CI process is defined by several entites:

* IaC code for the factory - terraform code in hs-application-infra repo
* Runtime definition (what will be executed from the factory) - buildspec file
* Output image definition - Dockerfile
* Validation scripts and artifacts - additional resources, like helmcharts, unit tests etc....

In order to be flexible enough and in addition to be maintainable and allow role separation, different entities are stored in different repos:

The terraform code is stored in hs-application-infra repo, and any change there is considered infrastructure change.

All other entities are stored in separate repo, which is tha application repo itself. This gives control on the runtime elements of the factory to the developers of the application and enables the corresponding DEV team to evolve the CI process together with the application evolution.

Validation
----------

CI feedback different statuses from CI process back to GHE commit status. This provides easy to access feedback, without requiring to track lenghty logs and to login in the AWS Cloud Console. This status can be set as required, thus blocking the merge into the main branch.

Currently these are the phases that CI will report back:

* webhook received
* codebuild started
* buildspec.py phases
* codebuild end


Triggers
--------

Every factory in the CI process, have a trigger mechanism that will start the factory and produce the image. Currently webhooks are used to start different codebuilds based on the GHE repo name, a lambda function identify and start corresponding AWS CodeBuild project.

In order to enable the webhook integration, this URL can be used, where optional codebuild_name parameter can be specified to trigger specific codebuild project.
