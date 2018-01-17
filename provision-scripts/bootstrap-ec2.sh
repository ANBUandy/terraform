#!/bin/sh
set -e

# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.
# Initialize our own variables:
HOSTNAME=""
ENVIRONMENT=""

while getopts "h:e:" opt; do
    case "$opt" in
    h)  HOSTNAME=$OPTARG
        ;;
    e)  ENVIRONMENT=$OPTARG
        ;;
    esac
done

shift $((OPTIND-1))

[ "$1" = "--" ] && shift

echo "[INFO]: HOSTNAME=${HOSTNAME}"
echo "[INFO]: ENVIRONMENT=${ENVIRONMENT}"
echo ""

echo "[INFO]: Bootstrap..."

until [ -f "/var/lib/cloud/instance/boot-finished" ]; do
  echo "[INFO]:  - Waiting for cloud-init to finish...sleeping 1 second"
  sleep 1
done

# Set up the hostname
if [ -n "${HOSTNAME}" ]; then
  echo "${HOSTNAME}" > /etc/hostname
  hostname ${HOSTNAME}
fi

# create the dexion user
echo "dexion ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/dexion-users
chmod 440 /etc/sudoers.d/dexion-users
useradd dexion || :
mkdir -p /home/dexion/.ssh
chmod 700 /home/dexion/.ssh
echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDoAiMDdiML3GkjBuGWM9+W0ndXolpe3ERdnTEjNQsFal76P9/FXsabF9QbuBXvvuHgPg29CO3lQEO0bPlYfmQQgCmef+jRSAJMN73oQSHUHOr5R1BDDEt2HqhXsVJstoTGlhuoInCSdl40402nrTy3NrAibICkqqJWCHEl7nTDIdvJ+THT+9qLpjWTf1MdKZzixnaHOMxbeh0xX35NOCi+dCJMTwFKBDotNbokY4nXZsMsPfv2SJTH/O7dk+27LVs5RnnRoIuJNMGtx+uXkiHp28VhPX9985/igjjcRJonBMZBMU+uFW23iHVIhJX4ePihfjbZKa8N0Dfu5rMJMasj andrew@andrew-VirtualBox' > /home/dexion/.ssh/authorized_keys
chmod 600 /home/dexion/.ssh/authorized_keys
chown -R dexion:dexion /home/dexion

# install python if system is ubuntu
if which apt-get; then
    apt-get install python
fi
