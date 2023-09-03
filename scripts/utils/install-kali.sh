#!/bin/bash

source "$(dirname $0)""/utils.sh"

ISO_URL='https://cdimage.kali.org/kali-2023.3/kali-linux-2023.3-virtualbox-amd64.7z'
DL_PATH='/sgoinfre/Perso/thdelmas/ISO/'

ISO_NAME='kali-linux-2023.3-virtualbox-amd64'
ISO_PATH="${DL_PATH}/${ISO_NAME}"
ISO_ARCHIVE_PATH="$ISO_PATH"'.7z'

DISK_PATH="${ISO_PATH}/${ISO_NAME}.vdi"

if ! [ "$1" ]
then
	echo "Usage: $0 <VM_NAME>"
	exit 1
fi

HOSTONLYNET_NAME="$(VBoxManage list hostonlynets | grep VBoxNetworkName | head -n1 | cut -d'-' -f2)"
if ! [ -e "$HOSTONLYNET_NAME" ]
then
	./"$(dirname $0)""/create-vbox-hostonlynet.sh"
	HOSTONLYNET_NAME="$(VBoxManage list hostonlynets | grep VBoxNetworkName | head -n1 | cut -d'-' -f2)"
fi


VM_NAME="$1"
VM_RAM="$((1024*2))"
VM_VRAM='32'

if ! [ -e "$DISK_PATH" ]
then
	rm -rf "$ISO_PATH"
	smartprint INFO 'Downloading ISO\n'
	curl -fsSL "$ISO_URL" -o "$ISO_ARCHIVE_PATH"
	cd "$DL_PATH"
	smartprint INFO 'Extracting ISO\n'
	tar -xvf "$ISO_ARCHIVE_PATH"
	cd -
fi

# Ensure VM exist or create it
if ! [ "$(vboxmanage list vms | grep "$VM_NAME")" ]
then
	VBoxManage createvm --name "$VM_NAME" --ostype 'Linux_64' --register 
	VBoxManage modifyvm "$VM_NAME" --memory "$VM_RAM" --vram "$VM_VRAM"
	VBoxManage modifyvm "$VM_NAME" --graphicscontroller vmsvga
	VBoxManage modifyvm "$VM_NAME" --nic1 "nat"
	VBoxManage modifyvm "$VM_NAME" --nat-pf1="ssh,tcp,,2222,,22"
	VBoxManage modifyvm "$VM_NAME" --nic2 "hostonlynet" --host-only-net2 "$HOSTONLYNET_NAME"
	VBoxManage storagectl "$VM_NAME" --name IDE --add ide
	VBoxManage storageattach "$VM_NAME" --storagectl IDE --port 0 --device 0 --type hdd --medium "${DISK_PATH}"
else
	smartprint ERROR "There is already a VM with the name: ${VM_NAME}\n"
fi

# Ensure VM is up or start it
if ! [ "$(vboxmanage list runningvms | grep "$VM_NAME")" ]
then
	VboxManage startvm "$VM_NAME"
	VBoxManage setextradata global GUI/MaxGuestResolution any
	VBoxManage setextradata "$VM_NAME" "CustomVideoMode1" "1366x768x32"
	VBoxManage controlvm "$VM_NAME" setvideomodehint 1366 768 32
else
	smartprint WARNING "VM with the name: ${VM_NAME} is already running\n"
fi
