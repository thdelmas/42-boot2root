#!/bin/bash

source "$(dirname $0)""/utils.sh"

# Ensure HostOnly Interface

# - - -

smartprint INFO "Creating Host only network\n"
HOSTONLYNET_NAME="$(VBoxManage list hostonlynets | grep VBoxNetworkName | head -n1 | cut -d'-' -f2)"

if ! [ "$HOSTONLYNET_NAME" ] || [ "$HOSTONLYNET_NAME" = "Legacy  Network" ]
then
	VBoxManage hostonlynet add --name toto --netmask '255.255.255.0' --lower-ip '192.168.42.0' --upper-ip '192.168.42.254'
	HOSTONLYNET_NAME="$(VBoxManage list hostonlynets | grep VBoxNetworkName | head -n1 | cut -d'-' -f2)"
	if ! [ "$HOSTONLYNET_NAME" ];
	then
		smartprint ERROR "Failed to create Host only network\nAbort\n"
		exit 1
	fi
else
	smartprint SUCCESS "Found HostOnlyNet: $HOSTONLYNET_NAME\n"
fi
