#!/bin/sh

# Output server ID
echo "server id (myid): ${SERVER_ID}"
echo "${SERVER_ID}" > /tmp/zookeeper/myid

# Start Zookeeper
/opt/zookeeper/bin/zkServer.sh start-foreground
