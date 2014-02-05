#!/bin/bash
################################################################################
## This script will export a virtual box image to a standard dated
## file and log the output.
## https://www.virtualbox.org/manual/ch08.html#vboxmanage-export
##
## export_golden.sh <VMNAME>
##
## VMNAME  = VM name to export
## OUTDIR  = directory to export VM file
## OUTFILE = Generated from VM name and date time.
##
## TODO: allow override of OUTDIR from command line arguments
## TODO: update LOG_DIR to be configurable or based on script location.
## TODO: more error checking
##
## LOG=`./export_golden.sh | grep -e "^LOG=" | sed "s/^LOG=\[\(.*\)\]/\1/"` ; 
## echo $LOG ;
## FILE=`cat $LOG | grep "export image:" | sed "s/^.* to file //"` ; 
## echo $FILE ;
## ./publish_image.sh $FILE "GoldImage"
##
## oneliner
## date ; LOG=`./export_golden.sh | grep -e "^LOG=" | sed "s/^LOG=\[\(.*\)\]/\1/"` ; echo $LOG ; FILE=`cat $LOG | grep "export image:" | sed "s/^.* to file //"` ; echo $FILE ; ./publish_image.sh $FILE "GoldImage" ; date
################################################################################
function usage {
    MESSAGE=$1
    echo "$MESSAGE"
    echo "export_golden.sh <VMNAME>"
    echo ""
    echo "VMNAME  = VM name to export"
}

OUTDIR=dist
#VMNAME="GoldImage"
VMNAME=$1

echo "VMNAME=[$VMNAME]"
if [[ -z "$VMNAME" ]] ; then
    usage "missing VMNAME"
    exit;
fi

################################################################################
## Standard logging - start
################################################################################
APP=export_golden.sh
TIMESTAMP=`date +%Y-%m-%d_%H%M%S`
## not sure the working directory makes sense, but how I am
## using the script PWD and the location of the script happen to be
## the same. This may not be the case if the script were run from cron
## or using a fully qualified path to the script.
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

DATETIME=`date +%Y-%m-%d_%H%M%S`
OUTFILE=${VMNAME}_${DATETIME}.ova
OUT=${OUTDIR}/${OUTFILE}

echo "Exporting ${VMNAME} to ${OUT}"

echo "list VMs"
vboxmanage list vms

echo "make sure VM is shutdown"
vboxmanage controlvm "${VMNAME}" acpipowerbutton
## ugly hack to sleep some period before shutdown completes.  need to figure out a way to poll if the vm is shutdown.
echo "pause for shutdown"
## slow machine (lab4) takes about  30s 
## fast machine (imagemaster) about  5s
sleep 40

## TODO: this script could take in a publish description and use this switch on the snapshot [--description <desc>]
echo "take snapshot"
vboxmanage snapshot "${VMNAME}" take "export ${OUTFILE}"

mkdir -p ${OUTDIR}
echo "export image: ${VMNAME} to file ${OUT}"
vboxmanage export "${VMNAME}" --output ${OUT}

################################################################################
## Standard logging - finish
################################################################################
END=`date`
echo "${START} - start"
echo "${END} - end"
} >> ${LOG} 2>&1
