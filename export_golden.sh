#!/bin/bash

OUTDIR=dist
IMAGE="IE10.Win7.For.MacVirtualBox_WBAH"

DATETIME=` date +%Y-%M-%d_%H%M%S`
OUT=${OUTDIR}/vmout_${DATETIME}.ova

# https://www.virtualbox.org/manual/ch08.html#vboxmanage-export
echo "list VMs"
vboxmanage list vms

mkdir -p ${OUTDIR}
echo "export image: ${IMAGE} to file ${OUT}"
vboxmanage export "${IMAGE}" --output ${OUT}
