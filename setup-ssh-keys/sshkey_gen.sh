#!/bin/sh
#

export WORKING_DIR=${PWD}
#  ssh-keygen -f "/home/user/.ssh/known_hosts" -R "[192.168.16.120]:42422"
#  ssh-keygen -o -a 100 -t ed25519 -f ~/.ssh/id_ed25519 -C "foo@example.com"
#  ssh-keygen -f "/home/user/.ssh/known_hosts" -t rsa -b 4096 ssh-keygen -t dsa ssh-keygen -t ecdsa -b 521 ssh-keygen -t ed25519

if [ -z "$1" ]
then
    SSH_KEY_PREFIX=any
else
    SSH_KEY_PREFIX=$1
fi

SSH_KEY_OUTPUT_FILE="${WORKING_DIR}/id_${SSH_KEY_PREFIX}.key"
SSH_KEY_COMMENT="user@service"

ssh-keygen -f "${SSH_KEY_OUTPUT_FILE}_rsa" -t rsa -b 4096 -C ${SSH_KEY_COMMENT}
ssh-keygen -f "${SSH_KEY_OUTPUT_FILE}_dsa" -t dsa  -C ${SSH_KEY_COMMENT} 
ssh-keygen -f "${SSH_KEY_OUTPUT_FILE}_ecdsa"  -t ecdsa -b 521 -C ${SSH_KEY_COMMENT}
ssh-keygen -f "${SSH_KEY_OUTPUT_FILE}_ed25519" -t ed25519  -C ${SSH_KEY_COMMENT}
