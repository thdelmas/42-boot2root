#!/bin/bash

source "$(dirname $0)""/utils.sh"

if ! [ "$1" ];
then
	echo "Usage: $0 <VM_NAME>"
	exit 1
fi

VM_NAME="$1"

UNREGISTER_TRIES="1"

smartprint "WARNING" "Powering off ${VM_NAME} VM\n"
# Ensure VM exist before deleting it
while [ "$(vboxmanage list vms | grep "$VM_NAME")" ]
do
	VBoxManage controlvm "$VM_NAME" poweroff 2>/dev/null
	sleep "$UNREGISTER_TRIES"
	VBoxManage unregistervm "$VM_NAME" --delete-all 2>/dev/null
	UNREGISTER_TRIES="$(($UNREGISTER_TRIES + 1))"
	if [ "$UNREGISTER_TRIES" -gt 4 ]
	then
		smartprint "ERROR" "Failed to remove ${VM_NAME} VM\n"
	fi
done

if ! [ "$(vboxmanage list vms | grep "$VM_NAME")" ]
then
	smartprint "SUCCESS" "$VM_NAME removed succesfully !\n"
else
	smartprint "ERROR" "Failed to remove the VM: ${VM_NAME}\n"
fi
