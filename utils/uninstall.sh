#!/bin/bash

if ! [ "$1" ];
then
	echo "Usage: $0 <VM_NAME>"
	exit 1
fi

VM_NAME="$1"

# Ensure VM exist before deleting it
if [ "$(vboxmanage list vms | grep "$VM_NAME")" ]
then
	VBoxManage controlvm "$VM_NAME" poweroff &&
	sleep 1 &&
	VBoxManage unregistervm "$VM_NAME" --delete-all 
else
	printf "${TC_RED}There is no VM with the name: ${VM_NAME}${TC_RESET}\n"
fi
