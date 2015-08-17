# docker build -t mesoscope/mesos-master .
# export HOST_IP=$(boot2docker ip)
# docker run --net="host" -p 5050:5050 -e "MESOS_HOSTNAME=${HOST_IP}" -e "MESOS_IP=${HOST_IP}" -e "MESOS_ZK=zk://${HOST_IP}:2181/mesos" -e "MESOS_PORT=5050" -e "MESOS_LOG_DIR=/var/log/mesos" -e "MESOS_QUORUM=1" -e "MESOS_REGISTRY=in_memory" -e "MESOS_WORK_DIR=/var/lib/mesos" -d mesoscope/mesos-master

FROM mesoscope/mesos-common

EXPOSE 5050

ENTRYPOINT ["mesos-master"]
