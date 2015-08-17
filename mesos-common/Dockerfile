# docker build -t mesoscope/mesos-common .

FROM mesoscope/common

RUN apt-get update && \
	apt-get install -y --no-install-recommends build-essential python-dev \
		python-boto libcurl4-nss-dev libsasl2-dev maven libapr1-dev libsvn-dev \
		autoconf automake libtool libsasl2-modules && \
	apt-get clean

RUN mkdir -p /opt/mesos
RUN wget -q -O - https://github.com/apache/mesos/archive/0.23.0.tar.gz | \
	tar -xzf - -C /opt/mesos --strip=1

WORKDIR /opt/mesos

RUN mkdir build
RUN ./bootstrap && cd build && ../configure && make && make install && ldconfig
