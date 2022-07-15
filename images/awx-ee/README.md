# AWX execution environment

The AWX execution environment is a container image that AWX will use to execute jobs in. Customising the image allows us to pre-install a number of system dependencies to ensure that the jobs can run correctly.

`ansible-builder` generates a Dockerfile that can be used to push images to dockerhub. It uses 4 files to generate the ansible runtime:

- `execution-environment.yml`: Defines additions to the generate dockerfile
- [`bindep.txt`](https://pypi.org/project/bindep/): Python program to manage system dependencies
- `requirements.txt`: Defined python dependencies
- `requirements.yml`: Ansible collections to install

AWX has `singledigital/awx-ee:latest` added as an execution environment with a pull policy of always, when the image is updated kuberenetes will pull a new image to run the plays in.

## Dependencies

- [`ansible-builder`](https://github.com/ansible/ansible-builder)

## Building the image

Commands run from this directory if you have ansible-builder installed locally.

```
$ ansible-builder build --tag singledigital/awx-ee:latest --container-runtime docker
```

OR run with docker.

```
# Generate the build artefacts
$ docker run --rm -it \
    -v $(pwd):/data \
    -w /data \
    quay.io/ansible/ansible-builder:latest \
      ansible-builder build --tag singledigital/awx-ee:latest --container-runtime docker

# Build the image
$ docker build -f context/Dockerfile -t singledigital/awx-ee:latest context
```

## Deploying the image

```
$ docker push singledigital/awx-ee:latest
```
