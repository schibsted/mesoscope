all: build compose

build: build-common build-zookeeper build-mesos-common build-mesos-master build-mesos-slave \
	build-mesos-marathon build-docker-registry

build-common:
	cd common && docker build -t mesoscope/common .

build-zookeeper: build-common
	cd zookeeper && docker build -t mesoscope/zookeeper .

build-mesos-common: build-common
	cd mesos-common && docker build -t mesoscope/mesos-common .

build-mesos-master: build-mesos-common
	cd mesos-master && docker build -t mesoscope/mesos-master .

build-mesos-slave: build-mesos-common
	cd mesos-slave && docker build -t mesoscope/mesos-slave .

build-mesos-marathon: build-mesos-common
	cd mesos-marathon && docker build -t mesoscope/mesos-marathon .

build-docker-registry: build-common
	cd docker-registry && docker build -t mesoscope/docker-registry .

compose:
	docker-compose up

destroy:
	docker-compose kill && docker-compose rm -f

test:
	cd test && sh test-mesoscope.sh

.PHONY: all build build-common build-zookeeper build-mesos-common build-mesos-master build-mesos-slave \
	build-mesos-marathon build-docker-registry compose destroy test
