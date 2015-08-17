# docker build -t mesoscope/common .

FROM ubuntu:14.04

RUN echo 'deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main' >> /etc/apt/sources.list && \
	echo 'deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main' >> /etc/apt/sources.list && \
	apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C2518248EEA14886

RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections

RUN apt-get update && \
	apt-get install -y --no-install-recommends oracle-java8-installer oracle-java8-set-default wget ca-certificates && \
	apt-get clean
