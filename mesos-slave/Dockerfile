# docker build -t mesoscope/mesos-slave .
# export HOST_IP=$(boot2docker ip)
# run -d --name mesos_slave_1 --entrypoint="mesos-slave" -e "MESOS_MASTER=zk://${HOST_IP}:2181/mesos" -e "MESOS_LOG_DIR=/var/log/mesos" -e "MESOS_LOGGING_LEVEL=INFO" mesoscope/mesos-slave

FROM mesoscope/mesos-common

RUN wget -qO- https://get.docker.com/ | sh

ADD start.sh /usr/local/bin/
RUN chmod 755 /usr/local/bin/start.sh

EXPOSE 5050

VOLUME ["/sys"]

ENTRYPOINT ["/usr/local/bin/start.sh"]
