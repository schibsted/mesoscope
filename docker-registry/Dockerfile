# docker build -t mesoscope/docker-registry .

FROM mesoscope/common

ENV GOLANG_VERSION="1.5.2.linux-amd64"
ENV GOPATH="/go"
ENV PATH="$GOPATH/bin:/usr/local/go/bin:$PATH"
ENV SRVPATH="/opt/docker-registry"

RUN apt-get update && \
	apt-get install -y --no-install-recommends git mercurial curl && \
	apt-get clean

RUN curl -sSL https://golang.org/dl/go${GOLANG_VERSION}.tar.gz | \
	tar -v -C /usr/local -xz

RUN mkdir -p ${GOPATH}
RUN go get -x github.com/tools/godep && \
	go get -x golang.org/x/sys/unix && \
	go get -x github.com/inconshreveable/mousetrap && \
	godep get github.com/docker/distribution/registry

RUN mkdir -p ${SRVPATH}/conf ${SRVPATH}/data
ADD files/config.yml ${SRVPATH}/conf/config.yml

EXPOSE 5000

ENTRYPOINT ["registry", "/opt/docker-registry/conf/config.yml"]
