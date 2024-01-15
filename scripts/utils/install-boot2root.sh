#!/bin/bash

source "$(dirname $0)""/utils.sh"

ISO_PATH='/sgoinfre/Perso/thdelmas/ISO/BornToSecHackMe-v1.1.iso'
ISO_URL='https://cdn.intra.42.fr/isos/BornToSecHackMe-v1.1.iso'

if ! [ "$1" ];
then
	echo "Usage: $0 <VM_NAME>"
	exit 1
fi

VM_NAME="$1"
VM_RAM="$((1024*4))"
VM_VRAM='32'

HOSTONLYNET_NAME="$(VBoxManage list hostonlynets | grep VBoxNetworkName | head -n1 | cut -d'-' -f2)"
if ! [ -e "$HOSTONLYNET_NAME" ]
then
	./"$(dirname $0)""/create-vbox-hostonlynet.sh"
	HOSTONLYNET_NAME="$(VBoxManage list hostonlynets | grep VBoxNetworkName | head -n1 | cut -d'-' -f2)"
fi

if ! [ -e "$ISO_PATH" ]
then
	smartprint INFO 'Downloading ISO\n'
	curl -fsSL "$ISO_URL" -o "$ISO_PATH"
fi

# Ensure VM exist or create it
if ! [ "$(vboxmanage list vms | grep "$VM_NAME")" ]
then
	VBoxManage createvm --name "$VM_NAME" --ostype 'Ubuntu_64' --register 
	VBoxManage modifyvm "$VM_NAME" --memory "$VM_RAM" --vram "$VM_VRAM"
	VBoxManage setextradata global GUI/MaxGuestResolution any
	VBoxManage modifyvm "$VM_NAME" --graphicscontroller vmsvga
	VBoxManage modifyvm "$VM_NAME" --nic1 "hostonlynet" --host-only-net1 "$HOSTONLYNET_NAME"
	VBoxManage modifyvm "$VM_NAME" --nic2 "nat"
	VBoxManage modifyvm "$VM_NAME" --nat-pf2="ssh,tcp,,43022,,22"
	VBoxManage modifyvm "$VM_NAME" --nat-pf2="http,tcp,,43080,,80"
	VBoxManage modifyvm "$VM_NAME" --nat-pf2="https,tcp,,43443,,443"
	VBoxManage storagectl "$VM_NAME" --name IDE --add ide
	VBoxManage storageattach "$VM_NAME" --storagectl IDE --port 0 --device 0 --type dvddrive --medium "$ISO_PATH"
else
	smartprint ERROR "There is already a VM with the name: ${VM_NAME}\n"
fi

# Ensure VM is up or start it
if ! [ "$(vboxmanage list runningvms | grep "$VM_NAME")" ]
then
	VboxManage startvm "$VM_NAME"
	smartprint SUCCESS 'Downloading ISO\n'
else
	smartprint WARNING "VM with the name: ${VM_NAME} is already running\n"
fi
