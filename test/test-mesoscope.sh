#!/bin/sh

PROVASHELL_VERSION='provashell-2.1.1'
[ ! -e provashell ] && curl -O "https://raw.githubusercontent.com/danigiri/provashell/$PROVASHELL_VERSION/src/main/sh/provashell"


#@Before
establishEnvironment() {

	[ -z "$MESOSCOPE_ROOT" ] && export MESOSCOPE_ROOT="../"

	[ -z "$DOCKER_SOCK" ] && export DOCKER_SOCK='/var/run/docker.sock'
	[ -S "$DOCKER_SOCK" ] && export ACTUAL_DOCKER_HOST='127.0.0.1'
	[ -z "$ACTUAL_DOCKER_HOST" ] && export ACTUAL_DOCKER_HOST=$(echo $DOCKER_HOST | sed -E 's,tcp://([^:]+):2376,\1,')

	if [ -z "$ACTUAL_DOCKER_HOST" ]; then
		echo "Error: Cannot get Docker host, remember to set the 'ACTUAL_DOCKER_HOST' env var if needed"
		exit 1
	fi

	[ -z "$DK_ZOOKEEPER_ID" ] &&  export DK_ZOOKEEPER_ID=$( docker ps | grep 'mesoscope/zookeeper' | awk '{print $1}' )
	[ -z "$DK_MESOSMASTER_ID" ] &&  export DK_MESOSMASTER_ID=$( docker ps | grep 'mesoscope/mesos-master' | awk '{print $1}' )
	[ -z "$DK_MESOSSLAVE_ID" ] &&  export DK_MESOSSLAVE_ID=$( docker ps | grep 'mesoscope/mesos-slave' | awk '{print $1}' )
	[ -z "$DK_MARATHON_ID" ] &&  export DK_MARATHON_ID=$( docker ps | grep 'mesoscope/mesos-marathon' | awk '{print $1}' )
	[ -z "$DK_REGISTRY_ID" ] &&  export DK_REGISTRY_ID=$( docker ps | grep 'mesoscope/docker-registry' | awk '{print $1}' )

}

#@Test
testZookeeper() {

	# check docker image is up
	assertDockerImageUp 'Zookeeper (is the system up?)' "$DK_ZOOKEEPER_ID" 2181

	# from the docker image list a nonexistant node in zookeeper and check for expected output
	zk_path_='/NON3XISTANTNODE123'
	docker_exec_="echo 'ls $zk_path_' | sudo -u nobody /opt/zookeeper/bin/zkCli.sh"
	docker_output_=$( docker exec "$DK_ZOOKEEPER_ID" bash -c "$docker_exec_" 2>&1 | grep Node )
	assertEquals "Listing nonexistant node in  ($docker_output_)" "Node does not exist: $zk_path_" "$docker_output_"

}

#@Test
testMesosMaster() {

	# check docker image is up
	assertDockerImageUp 'Mesos Master' "$DK_MESOSMASTER_ID" 5050

}

#@Test
testMesosSlave() {

	# check docker image is up
	assertDockerImageUp 'Mesos Slave' "$DK_MESOSSLAVE_ID" 5051

}

#@Test
testMarathon() {

	# check docker image is up
	assertDockerImageUp 'Marathon' "$DK_MARATHON_ID" 8080

	# marathon health check
	marathon_response_=$(http_get "$ACTUAL_DOCKER_HOST:8080/ping")
	assertEquals 'pong' "$marathon_response_"

}

#@Test
testDockerRegistry() {

	# check docker image is up
	assertDockerImageUp 'Docker Registry' "$DK_REGISTRY_ID" 5000

	testapp_tag_="$ACTUAL_DOCKER_HOST:5000/mesoscope-testapp-non3xistantimage:$(awk 'BEGIN{srand();print int(rand()*1000)}')"
	testapp_image_=$( docker images | grep "$testapp_tag_" )

	# build + push + rmi + pull to guarantee that we use the pushed image
	echo 'Building and pushing the testapp image (takes a while)...'
	assertDockerCmd "build -t $testapp_tag_ $MESOSCOPE_ROOT/testapp/" 'build of testapp failed'
	assertDockerCmd "push $testapp_tag_" "failed to push image '$testapp_tag_', do you need to set the env var ACTUAL_DOCKER_HOST?"
	assertDockerCmd "rmi -f $testapp_tag_" 'rmi of testapp failed'
	assertDockerCmd "pull $testapp_tag_" 'pull of testapp failed'

	# run the image and check if the service is up
	assertDockerCmd "run -d -P $testapp_tag_" 'running the testapp failed'
	sleep 5
	ta_port_=$( docker ps | grep "$testapp_tag_" | sed -E 's,.*:([^-]+)->8001/tcp.*,\1,' )
	assertN 'The test application is not up' "$ta_port_"

	assertTCPConnect "Cannot reach the test application" "$ACTUAL_DOCKER_HOST" "$ta_port_"

	# kill all instances
	docker ps | grep "$testapp_tag_" | awk '{print $1}' | xargs docker kill > /dev/null
	assertDockerCmd "rmi -f $testapp_tag_" 'final rmi cleanup of testapp failed'

}

PS_EXIT_ON_FAIL=1
PS_FAILS_TO_STDERR=1
PS_VERBOSE=1

. ./helpers/docker.sh
. ./helpers/http.sh
. ./provashell
