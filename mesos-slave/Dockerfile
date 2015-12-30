# docker build -t mesoscope/mesos-slave .
# export HOST_IP=$(boot2docker ip)
# run -d --name mesos_slave_1 --entrypoint="mesos-slave" -e "MESOS_MASTER=zk://${HOST_IP}:2181/mesos" -e "MESOS_LOG_DIR=/var/log/mesos" -e "MESOS_LOGGING_LEVEL=INFO" mesoscope/mesos-slave

FROM mesoscope/mesos-common

RUN apt-get update && apt-get install -y --no-install-recommends \
	apt-transport-https \
	ca-certificates \
	curl \
	lxc \
	iptables

RUN curl -sSL https://get.docker.com/ | sh

ADD start.sh /usr/local/bin/
RUN chmod 755 /usr/local/bin/start.sh

# workdir for the slave, as slaves start in --strict recovery mode, we need a sane workdir in place 
RUN mkdir -p /var/mesos/meta/slaves

EXPOSE 5050

ENTRYPOINT ["/usr/local/bin/start.sh"]
