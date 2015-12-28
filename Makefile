MESOS_VER=0.26.0
MESOS_HELPER_URL=https://codeload.github.com/danigiri/mesos-build-helper/zip/$(MESOS_VER) 

all: build compose

build: build-common build-zookeeper build-mesos-common build-mesos-master build-mesos-slave \
	build-mesos-marathon build-docker-registry

build-common:
	cd common && docker build -t mesoscope/common .

build-zookeeper: build-common
	cd zookeeper && docker build -t mesoscope/zookeeper .

mesos-common/mesos-$(MESOS_VER)-1.x86_64.rpm:
	mkdir -p tmp && cd tmp && curl -s -S "$(MESOS_HELPER_URL)" -o mesos-build-helper-$(MESOS_VER).zip
	unzip -q -u tmp/mesos-build-helper-$(MESOS_VER).zip -d tmp
	DOCKER_FILE=Dockerfile-ubuntu cd tmp/mesos-build-helper-$(MESOS_VER) && source ./script/build
	cp -v tmp/mesos-build-helper-$(MESOS_VER)/mesos-$(MESOS_VER)-1.x86_64.rpm mesos-common

build-mesos-common: build-common mesos-common/mesos-$(MESOS_VER)-1.x86_64.rpm
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
