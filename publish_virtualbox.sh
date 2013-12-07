#!/bin/bash

PUB_USER=workstation
VMIMAGES_DIR=/home/${PUB_USER}/VMImages

IMAGE=$1
IMAGENAME=`basename ${IMAGE}`

echo "Publish image: [${IMAGENAME}] [${IMAGE}]"
SERVERS="\
192.168.42.108 \
"

for SERVER in ${SERVERS} ; do
    REMOTE=${PUB_USER}@${SERVER}
    echo "Publish to ${REMOTE}"
    ssh ${PUB_USER}@${SERVER} "mkdir -p ${VMIMAGES_DIR}"
    scp ${IMAGE} ${PUB_USER}@${SERVER}:${VMIMAGES_DIR}
    ssh ${PUB_USER}@${SERVER} "sudo dpkg -i ${VMIMAGES_DIR}/${IMAGENAME}"
done
