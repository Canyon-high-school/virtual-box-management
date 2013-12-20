#!/bin/bash

################################################################################
## Standard logging - start
################################################################################
#TODO: extract or make LOG_DIR path relative
LOG_DIR=/Users/lblackb/VMImages/virtual-box-management/log

APP=setup_host_account.sh
mkdir -p ${LOG_DIR}
TIMESTAMP=`date +%Y-%m-%d_%H%M%S`
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

REMOTE_HOST=$1
REMOTE_ADMIN_USER=$2
REMOTE_USER=$3

REMOTE_HOST=lab4.local
REMOTE_ADMIN_USER=blackburn
REMOTE_USER=workstation

TMP_DIR=/tmp/${USER}.$$

PUBLIC_KEY=$HOME/.ssh/id_rsa.pub

#
# With two password prompts, this function will get ssh authorized_keys
# setup to provide management of the remote account without passwords.
#
function install_authorized_key {
    RUSER=$1
    RHOST=$2

    ##fix the rest of the references

    if [ -e $PUBLIC_KEY ]
    then
	echo "Found public key $PUBLIC_KEY"
	TMP_AUTH_KEYS=${TMP_DIR}/authorized_keys
	cat ${PUBLIC_KEY} > ${TMP_AUTH_KEYS}
	chmod 644 ${TMP_AUTH_KEYS}

	REMOTE=${RUSER}@${RHOST}
	RUSER_SSH_DIR=/home/${RUSER}/.ssh
	ssh ${REMOTE} "mkdir -p ${RUSER_SSH_DIR}"
	echo "fix permission on .ssh dir"
	ssh ${REMOTE} "chmod 700 ${RUSER_SSH_DIR}"

	scp ${TMP_AUTH_KEYS} ${REMOTE}:${RUSER_SSH_DIR}

	echo "test key connect"
	ssh ${REMOTE} hostname

    else
	echo "No public key found.  Each connection will need to be authenticated with a password."
    fi
}

function create_remote_user {
    RADMIN=$1
    RHOST=$2
    RUSER=$3

    REMOTE=${RADMIN}@${RHOST}
    #TODO: start here.  sudo usage needs work.  need to consider pushing one script to run under sudo.;  need to figure out how to send multipe commands through sudo.
#    ssh -t ${REMOTE} "sudo /usr/sbin/useradd -m ${REMOTE_USER}"
    
    RADMIN_AUTH_KEYS=/home/${RADMIN}/.ssh/authorized_keys
    RUSER_SSH_DIR=/home/${RUSER}/.ssh
    RUSER_AUTH_KEYS=${RUSER_SSH_DIR}/authorized_keys

    COMMAND=""
    COMMAND="$COMMAND /usr/sbin/useradd -m ${REMOTE_USER} ; "
    COMMAND="$COMMAND mkdir -p ${RUSER_SSH_DIR} ; "
    COMMAND="$COMMAND cp ${RADMIN_AUTH_KEYS} ${RUSER_AUTH_KEYS} ; "
    COMMAND="$COMMAND chown -Rh $RUSER:$RUSER ${RUSER_SSH_DIR} ; "
    COMMAND="$COMMAND chmod 700 ${RUSER_SSH_DIR} ; "
    COMMAND="$COMMAND ls -la ${RUSER_SSH_DIR} ; "

    ssh -t ${REMOTE} "sudo sh -c '$COMMAND'"
}

echo "~1 Create tmp dir"
mkdir -p ${TMP_DIR}
echo "~2 Setup remote admin keys: ${REMOTE_ADMIN_USER} ${REMOTE_HOST}"
install_authorized_key ${REMOTE_ADMIN_USER} ${REMOTE_HOST}

echo "~3 create user ${REMOTE_USER} on ${REMOTE_HOST}"
create_remote_user ${REMOTE_ADMIN_USER} ${REMOTE_HOST} ${REMOTE_USER}

#echo "List tmp dir: ${TMP_DIR}"
#ls -la ${TMP_DIR}
echo "Remove tmp dir"
rm -r ${TMP_DIR}

################################################################################
## Standard logging - finish
################################################################################
END=`date`
echo "${START} - start"
echo "${END} - end"
} 
#>> ${LOG} 2>&1

cat $LOG