# docker build -t mesoscope/zookeeper .
# docker run -d -p 2181:2181 -p 2888:2888 -p 3888:3888 -e "SERVER_ID=mesoscope-zookeeper-1" mesoscope/zookeeper

FROM mesoscope/common

RUN mkdir -p /opt/zookeeper /tmp/zookeeper
RUN wget -q -O - http://www.eu.apache.org/dist/zookeeper/stable/zookeeper-3.4.8.tar.gz | \
	tar -xzf - -C /opt/zookeeper --strip=1
RUN cp /opt/zookeeper/conf/zoo_sample.cfg /opt/zookeeper/conf/zoo.cfg

ADD ./run.sh /opt/run.sh
RUN chmod 755 /opt/run.sh

WORKDIR /opt/zookeeper

EXPOSE 2181 2888 3888

CMD ["/opt/run.sh"]
