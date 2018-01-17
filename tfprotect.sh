#!/bin/bash
set -e

FILES="terraform.tfstate terraform.tfstate.backup"
# use the aws secret to encrypt/decrypt the terraform state files
KEY=$(cat ~/.aws/credentials | grep aws_secret_access_key | tail -n1 | awk '{print $3}')
ACTION="${1}"
DEST_FILE=terraform_state_encrypted

if [ -z $ACTION ]; then
    echo Usage:
    echo "$0 [encrypt|decrypt]"
    exit 1
fi

if [ "${ACTION}" == "encrypt" ]; then
    zip  -P ${KEY} ${DEST_FILE} ${FILES}
    mv ${DEST_FILE}.zip ${DEST_FILE}
    rm -f ${FILES}
fi
if [ "${ACTION}" == "decrypt" ]; then
    unzip -P ${KEY} ${DEST_FILE}
    rm ${DEST_FILE}
fi
echo Done.
