#!/bin/bash

#for the ubuntu systems
PUB_USER=workstation
VMIMAGES_DIR=/home/${PUB_USER}/VMImages
SERVERS="\
192.168.42.108 \
"

#for the mac
PUB_USER=lblackb
VMIMAGES_DIR=/Users/${PUB_USER}/VMImages
SERVERS="\
192.168.42.109 \
"

IMAGE=$1
IMAGENAME=`basename ${IMAGE}`

echo "Publish image: [${IMAGENAME}] [${IMAGE}]"
ls -lh ${IMAGE}


for SERVER in ${SERVERS} ; do
    REMOTE=${PUB_USER}@${SERVER}
    echo "Publish to ${REMOTE}"
    ssh ${PUB_USER}@${SERVER} "mkdir -p ${VMIMAGES_DIR}"
    scp $IMAGE ${PUB_USER}@${SERVER}:${VMIMAGES_DIR}
    ssh ${PUB_USER}@${SERVER} "ls -lh ${VMIMAGES_DIR}/${IMAGENAME}"
    ssh ${PUB_USER}@${SERVER} "vboxmanage import ${VMIMAGES_DIR}/${IMAGENAME}"
#    ssh ${PUB_USER}@${SERVER} "vboxmanage import --dry-run ${VMIMAGES_DIR}/${IMAGENAME}"
#    vboxmanage import --dry-run /home/workstation/VMImages/vmout_2013-35-06_223552.ova
done
