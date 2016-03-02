# docker build -t mesoscope/mesos-common .

FROM mesoscope/common

ENV MESOS_PACKAGE mesos-0.27.1-1.x86_64.rpm 

# following this http://mesos.apache.org/gettingstarted/
RUN apt-get update && \
	apt-get install -y --no-install-recommends build-essential \
		python-boto libcurl4-nss-dev libsasl2-dev libapr1-dev libsvn-dev \
		autoconf automake libtool libsasl2-modules && \
	apt-get install -y --no-install-recommends rpm && \
	apt-get clean

# TODO: check when sasl has latest and remove this
# .deb repos have version .25 which does not install libsasl2.so.3
RUN wget ftp://ftp.cyrusimap.org/cyrus-sasl/cyrus-sasl-2.1.26.tar.gz
RUN tar zxf cyrus-sasl-2.1.26.tar.gz && cd cyrus-sasl-2.1.26 && \
	./configure CC=gcc-4.8 CPPFLAGS=-I/usr/include/openssl --enable-cram && \
	make && \
	make install
RUN rm -f cyrus-sasl-2.1.26.tar.gz
RUN rm -rf cyrus-sasl-2.1.26

# TODO: fix this hack
# .deb repos have slightly different dependency linking names
RUN cd /usr/lib/x86_64-linux-gnu && \
	ln -s libsvn_delta-1.so.1.0.0 libsvn_delta-1.so.0 && \
	ln -s libsvn_subr-1.so.1.0.0 libsvn_subr-1.so.0 && \
	ln -s libcurl-nss.so libcurl.so.4

COPY ${MESOS_PACKAGE} .
RUN rpm -ivh --nodeps ${MESOS_PACKAGE} && \
 rm -f ${MESOS_PACKAGE}

