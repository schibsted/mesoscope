#!/bin/bash

exec mesos-slave $@ --containerizers=docker
