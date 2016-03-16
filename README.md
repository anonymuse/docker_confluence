[![Circle CI](https://circleci.com/gh/anonymuse/docker_confluence.svg?style=svg)](https://circleci.com/gh/anonymuse/docker_confluence)

# Confluence in Docker

## Getting started

**!!WARNING!!** this guide is not yet functional

Do you want Confluence? This is how you get Confluence:

```
docker run --detach --publish 8090:8090 anonymuse/confluence-docker:latest
```

## Building Your Stack

There's a Makefile available to help you get your cluster set up. To see what commands are available, type `make help` at the command prompt.

#TODO: Outline build, run, update, deploy

Once you finish making changes to your image, you can push it to the Docker Hub, using the deployment command. You'll need to add your own namespace so you can upload the image to your account.

> Note: you must be logged into the Docker Hub with `docker login` in order to push images.

Let's push!

```
$ make confluence_deploy NAMESPACE=<your_namespace>
```
