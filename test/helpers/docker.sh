#!/bin/sh

assertDockerCmd() {

	cmd_=$1
	msg_=$2

	exit_code_=$( docker $cmd_ > /dev/null ; echo $? )
	assertEq "$msg_ ($exit_code_)" 0 "$exit_code_"

}

assertDockerImageUp() {

	service_="$1"
	id_="$2"
	port_="$3"

	assertN "Did not get any docker ID of $service_" "$id_"

	# check docker image is up
	svc_up_=$( docker ps | grep "$id_" -q ; echo $? )
	assertEq "The $service_ service is not up ($svc_up_)" 0 "$svc_up_"

	# check if the tcp port of the service is accessible
	assertTCPConnect "Cannot reach the test $service_ at port $port_" "$ACTUAL_DOCKER_HOST" "$port_"

}
