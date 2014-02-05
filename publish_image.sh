#!/bin/bash
################################################################################
## This script will publish a virtual box image to a set of servers
## and takes two input parameters.
##
## publish_image.sh <IMAGE> <VMNAME>
##
## IMAGE  = full path to virtual box export file.
## VMNAME = VM name to replace on target system with exported image file.
##
## For now the list of servers is hard coded in the SERVERS variable.
## TODO: externalize SERVERS list
## TODO: update LOG_DIR to be configurable or based on script location.
################################################################################
function usage {
    MESSAGE=$1
    echo "$MESSAGE"
    echo "publish_image.sh <IMAGE> <VMNAME> '<SERVERS>'"
    echo ""
    echo "IMAGE   = full path to virtual box export file."
    echo "VMNAME  = VM name to replace on target system with exported image file."
    echo "SERVERS = space delimited list of server names.  yes you need the quote and yes there are probably better ways."
}

IMAGE=$1
echo "IMAGE=[$IMAGE]"
if [[ -z "$IMAGE" ]] ; then
    usage "missing IMAGE"
    exit;
fi

VMNAME=$2
echo "VMNAME=[$VMNAME]"
if [[ -z "$VMNAME" ]] ; then
    usage "missing VMNAME"
    exit;
fi

SERVERS=$3
echo "SERVERS=[$SERVERS]"
if [[ -z "$SERVERS" ]] ; then
    usage "missing SERVERS"
    exit;
fi

#SERVERS="\
#imagemaster.local \
#"
##lab4.local \

################################################################################
## Standard logging - start
################################################################################
APP=publish_image.sh
TIMESTAMP=`date +%Y-%m-%d_%H%M%S`
## TODO: update LOG_DIR to be configurable or based on script location.
LOG_DIR=${PWD}/log
mkdir -p ${LOG_DIR}
LOG=${LOG_DIR}/${APP}_${TIMESTAMP}.log

echo "LOG=[${LOG}]"
{
HOST=`hostname`
USER=`id -un`
LOG_ID="${USER}@${HOST}:$$:${PWD}:$0"

echo "LOG=[${LOG}]"
echo "LOG_ID=[$LOG_ID}]"
START=`date`
echo "${START} - start"
################################################################################
## Standard logging - end
################################################################################

#for the ubuntu systems
PUB_USER=workstation
VMIMAGES_DIR=/home/${PUB_USER}/VMImages/images/dist

IMAGENAME=`basename ${IMAGE}`
echo "Publish image: [${IMAGENAME}] [${IMAGE}]"
ls -lh ${IMAGE}

for SERVER in ${SERVERS} ; do
    echo "~1"
    REMOTE=${PUB_USER}@${SERVER}
    echo "~2 Publish to ${REMOTE}"
    echo "~3 mkdir ${VMIMAGES_DIR}"
    ssh ${REMOTE} "mkdir -p ${VMIMAGES_DIR}"
    echo "~4 copy image"
    scp $IMAGE ${REMOTE}:${VMIMAGES_DIR}
    echo "~5 list image"
    ssh ${REMOTE} "ls -lh ${VMIMAGES_DIR}/${IMAGENAME}"
    echo "~6a ungegister vm - shutdown"
    ssh ${REMOTE} "vboxmanage controlvm \"${VMNAME}\" acpipowerbutton"
## ugly hack to sleep some period before shutdown completes.  need to figure out a way to poll if the vm is shutdown.
    echo "~6b ungegister vm - pause for shutdown"
    ## slow machine (lab4) takes about  30s 
    ## fast machine (imagemaster) about  5s
    sleep 40
    echo "~6c ungegister vm"
    ssh ${REMOTE} "vboxmanage unregistervm --delete \"${VMNAME}\""
    echo "~7 import vm"
    ssh ${REMOTE} "vboxmanage import ${VMIMAGES_DIR}/${IMAGENAME}"
####    ssh ${PUB_USER}@${SERVER} "vboxmanage import --dry-run ${VMIMAGES_DIR}/${IMAGENAME}"
    echo "~8 start vm"
    ## slow machine (lab4) takes about  2m30s 
    ## fast machine (imagemaster) about   30s
    ssh ${REMOTE} "vboxmanage startvm \"${VMNAME}\""
done
################################################################################
## Standard logging - finish
################################################################################
END=`date`
echo "${START} - start"
echo "${END} - end"
} >> ${LOG} 2>&1
