#!/bin/sh

TD_IMG=${TD_IMG:-${PWD}/image/tdx-guest-ubuntu-24.04-generic.qcow2}
TDVF_FIRMWARE=/usr/share/ovmf/OVMF.fd

PROCESS_NAME=td
QUOTE_VSOCK_ARGS="-device vhost-vsock-pci,guest-cid=3"

PORT_MAP="hostfwd=tcp::10022-:22"
PORT_MAP="${PORT_MAP},hostfwd=tcp::8000-:8000"

if ! groups | grep -qw "kvm"; then
    echo "Please add user $USER to kvm group to run this script (usermod -aG kvm $USER and then log in again)."
    exit 1
fi

qemu-system-x86_64 \
		   -accel kvm \
		   -m 16G -smp 16 \
		   -name ${PROCESS_NAME},process=${PROCESS_NAME},debug-threads=on \
		   -cpu host \
		   -chardev stdio,id=ser0,signal=on -serial chardev:ser0 \
		   -object '{"qom-type":"tdx-guest","id":"tdx","quote-generation-socket":{"type": "vsock", "cid":"2","port":"4050"}}' \
		   -machine q35,kernel_irqchip=split,confidential-guest-support=tdx,hpet=off \
		   -bios ${TDVF_FIRMWARE} \
		   -nographic \
		   -nodefaults \
		   -device virtio-net-pci,netdev=nic0_td -netdev user,id=nic0_td,${PORT_MAP} \
		   -drive file=${TD_IMG},if=none,id=virtio-disk0 \
		   -device virtio-blk-pci,drive=virtio-disk0 \
		   ${QUOTE_VSOCK_ARGS}

