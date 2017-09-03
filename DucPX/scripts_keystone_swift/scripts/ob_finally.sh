#!/bin/bash -ex

source variable.cfg
source function.sh

chown -R root:swift /etc/swift
swift-init all start
