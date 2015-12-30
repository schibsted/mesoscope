![mesoscope](https://cloud.githubusercontent.com/assets/1223476/10282235/ee246ce6-6b79-11e5-87a3-e5e2bfe1a8d7.png)

## Introduction

Mesoscope is a project aimed at providing an easy-to-deploy environment
for getting started with [Mesos](http://mesos.apache.org/). The
idea behind this project is studying how mesos works and giving a
useful environment to deploy other components on top of it.

This repository contains a local setup of a Mesos cluster  that runs on top of
[Docker](https://www.docker.com/). It also starts a
[Docker Registry](https://docs.docker.com/registry/) server and a
[Marathon](https://mesosphere.github.io/marathon/) instance, which
makes very easy to deploy and run docker images via Mesos' docker
executor.

More docker images for other components are coming. For instance:
* Chronos
* Netflix OSS stack


## TL; DR

In sort, it’s as easy as following the next steps: Install docker
and docker-compose and run `make`. After doing this, you
will have a local mesos cluster up and running.

**IMPORTANT:** docker-compose makes the mesos-slave containers to
share the docker's UNIX socket with their host.


## Dependencies

To deploy this development environment, it is needed to install and properly
configure the following components before:
* [docker](https://www.docker.com/)
* [docker-compose](https://docs.docker.com/compose/)

Depending on your environment (e.g. OSX), you might need 
[docker-machine](https://docs.docker.com/machine/).

The build leverages
[mesos-build-helper](https://github.com/danigiri/mesos-build-helper) to build
and cache an RPM version of Mesos for faster re-builds of the system. This is
handled automagically by Mesoscope so there is no need to clone that project
manually.

## Usage

### Before you start

#### Building time

The first time you build the docker images, Mesos needs to be compiled. This
means that it can take a while, so take a cup of coffee and be patient :)

#### docker-machine

If you use docker-machine, it is recommended to assign it at least 2GB of RAM.

### Bring up the environment

Execute the following command: `make` (which is the same that `make build && make compose`)

The following control panels will be exposed:
* Mesos: `http://dockermachine-vm:5050/`
* Marathon: `http://dockermachine-vm:8080/`

![gif1](https://cloud.githubusercontent.com/assets/1223476/9304778/10b268a8-44ec-11e5-9c15-b1d630177516.gif)

### Build individual images:

It is also possible to build only a group of selected images using the
following make targets:
* All components: `make build`
* Zookeeper: `make build-zookeeper`
* Mesos Master: `make build-mesos-master`
* Mesos Slave: `make build-mesos-slave`
* Marathon: `make build-mesos-marathon`
* Docker Registry: `make build-docker-registry`

### Access to slave's links via mesos' console:

Just add to your `/etc/hosts` one entry like the following one for each slave:

```
<docker_host_ip>  d2b55aeb8b4d
```

Where d2b55aeb8b4d is the hostname of the mesos slave.

### Push images to the docker-registry:

The docker registry included in this testing environment only allows HTTP
connections, so you will need to start the docker daemon with the
parameter `--insecure-registry dockermachine-vm:5000`.

In the case of **docker-machine**, you can do it with the following (remember
to add the entry `dockermachine-vm` IP on /etc/hosts on your machine):

```
docker-machine create --driver virtualbox  --engine-insecure-registry dockermachine-vm  --virtualbox-memory '2048' dockermachine-vm
```

After doing this, you can push new images to the registry using these commands:

```
$ docker tag image_name dockermachine-vm:5000/image_name
$ docker push dockermachine-vm:5000/image_name
```

![gif2](https://cloud.githubusercontent.com/assets/1223476/9304780/1783a840-44ec-11e5-9cf9-9505c253e556.gif)

Finally, use the Marathon API to deploy your app:

```
$ cat testapp/testapp.json
{
	"id": "testapp",
	"cpus": 0.1,
	"mem": 16.0,
	"instances": 1,
	"container": {
		"type": "DOCKER",
		"docker": {
			"image": "dockermachine-vm:5000/image_name:latest",
			"network": "BRIDGE",
			"portMappings": [
				{ "containerPort": 8001, "hostPort": 0, "servicePort": 8001, "protocol": "tcp" }
			]
		}
	}
}

$ curl -X POST -H "Content-Type: application/json" http://dockermachine-vm:8080/v2/apps -d@testapp.json
```

![gif3](https://cloud.githubusercontent.com/assets/1223476/9304784/1b6c38be-44ec-11e5-87e5-693829c410d8.gif)

### Destroy the running environment

Execute the command `make destroy`

## Highlights

* All images are built using the source code of the different components
  directly from their official locations. We do it this way to avoid
  dependencies with 3rd-parties, etc.
* Only the installation of dependencies (wget, gcc, etc.) are distro-centric.

## Caveats

At the moment only the Docker containerizer is supported.

## More information

You can give a look to the file `docker-compose.yml` if you want to know which
other ports are exposed, the dependencies between images, etc.

## License

Copyright 2015 Schibsted Products and Technology

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
