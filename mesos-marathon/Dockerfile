# docker build -t mesoscope/mesos-marathon .
# export HOST_IP=$(boot2docker ip)
# docker run -d -p 8080:8080 mesoscope/mesos-marathon --master zk://${HOST_IP}:2181/mesos --zk zk://${HOST_IP}:2181/marathon

FROM mesoscope/mesos-common

RUN mkdir -p /opt/marathon
RUN wget -q -O - http://downloads.mesosphere.com/marathon/v0.15.2/marathon-0.15.2.tgz | \
	tar -xzf - -C /opt/marathon --strip=1

WORKDIR /opt/marathon

EXPOSE 8080

CMD ["--help"]
ENTRYPOINT ["/opt/marathon/bin/start"]
