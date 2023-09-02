#!/bin/bash

ISO_PATH='/sgoinfre/Perso/thdelmas/ISO/BornToSecHackMe-v1.1.iso'
ISO_URL='https://cdn.intra.42.fr/isos/BornToSecHackMe-v1.1.iso'

if ! [ "$1" ];
then
	echo "Usage: $0 <VM_NAME>"
	exit 1
fi

VM_NAME="$1"
VM_RAM="$((1024*1))"
VM_VRAM='32'

if ! [ -e "$ISO_PATH" ]
then
	echo 'Downloading ISO'
	curl -fsSL "$ISO_URL" -o "$ISO_PATH"
fi

# Ensure VM exist or create it
if ! [ "$(vboxmanage list vms | grep "$VM_NAME")" ]
then
	VBoxManage createvm --name "$VM_NAME" --ostype 'Ubuntu_64' --register 
	VBoxManage modifyvm "$VM_NAME" --memory "$VM_RAM" --vram "$VM_VRAM"
	VBoxManage modifyvm "$VM_NAME" --graphicscontroller vmsvga
	VBoxManage setextradata global GUI/MaxGuestResolution any
	VBoxManage modifyvm "$VM_NAME" --nic1 "nat"
	VBoxManage storagectl "$VM_NAME" --name IDE --add ide
	VBoxManage storageattach "$VM_NAME" --storagectl IDE --port 0 --device 0 --type dvddrive --medium "$ISO_PATH"
else
	printf "${TC_RED}There is already a VM with the name: ${VM_NAME}${TC_RESET}\n"
fi

# Ensure VM is up or start it
if ! [ "$(vboxmanage list runningvms | grep "$VM_NAME")" ]
then
	VboxManage startvm "$VM_NAME"
else
	printf "${TC_RED}VM with the name: ${VM_NAME} is already running${TC_RESET}\n"
fi
