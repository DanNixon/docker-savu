# Savu in Docker

[![Docker Pulls](https://img.shields.io/docker/pulls/dannixon/savu)](https://hub.docker.com/r/dannixon/savu)

[Savu](https://github.com/DiamondLightSource/Savu) running in Docker.

Based on the [Dockerfile in the Savu repo](https://github.com/DiamondLightSource/Savu/tree/master/docker-image).
I think this maybe is now maintained, as I no longer really work with Savu you may be better off using that image.

Ideally should be used with [nvidia-docker](https://github.com/NVIDIA/nvidia-docker) runtime, but will function without it (using only CPU algorithms).

## Usage

Run:
```bash
docker run \
  --rm -it \
  --runtime=nvidia \
  dannixon/savu:latest
```

It is possible to specify a custom Savu source tree (useful for development or using unreleased versions):
```bash
docker run \
  --rm -it \
  --runtime=nvidia \
  -v ~/my_savu:/savu_custom \
  dannixon/savu:latest
```

You will more than likely want to assign some volumes to access raw data and save processed data too.
