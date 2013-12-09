#!/bin/bash

#for the ubuntu systems
PUB_USER=workstation
VMIMAGES_DIR=/home/${PUB_USER}/VMImages/images/dist
SERVERS="\
imagemaster.local \
lab4.local \
"

#for the mac
#PUB_USER=lblackb
#VMIMAGES_DIR=/Users/${PUB_USER}/VMImages
#SERVERS="\
#192.168.42.109 \
#"

IMAGE=$1
IMAGENAME=`basename ${IMAGE}`
VMNAME="IE10.Win7.For.MacVirtualBox_WBAH"
echo "Publish image: [${IMAGENAME}] [${IMAGE}]"
ls -lh ${IMAGE}


for SERVER in ${SERVERS} ; do
    echo "~1"
    REMOTE=${PUB_USER}@${SERVER}
    echo "~2 Publish to ${REMOTE}"
    echo "~3 mkdir ${VMIMAGES_DIR}"
    ssh ${REMOTE} "mkdir -p ${VMIMAGES_DIR}"
    echo "~4 copy image"
#    scp $IMAGE ${REMOTE}:${VMIMAGES_DIR}
    echo "~5 list image"
    ssh ${REMOTE} "ls -lh ${VMIMAGES_DIR}/${IMAGENAME}"
    echo "~6a ungegister vm - shutdown"
    ssh ${REMOTE} "vboxmanage controlvm \"${VMNAME}\" acpipowerbutton"
## ugly hack to sleep some period before shutdown completes.  need to figure out a way to poll if the vm is shutdown.
    echo "~6b ungegister vm - pause for shutdown"
    sleep 10
    echo "~6c ungegister vm"
    ssh ${REMOTE} "vboxmanage unregistervm --delete \"${VMNAME}\""
    echo "~7 import vm"
    ssh ${REMOTE} "vboxmanage import ${VMIMAGES_DIR}/${IMAGENAME}"
#    ssh ${PUB_USER}@${SERVER} "vboxmanage import --dry-run ${VMIMAGES_DIR}/${IMAGENAME}"
#    vboxmanage import --dry-run /home/workstation/VMImages/vmout_2013-35-06_223552.ova

    echo "~8 start vm"
    ssh ${REMOTE} "vboxmanage startvm \"${VMNAME}\""
done
