#!/bin/bash
set -eux

ANSIBLE_VERSION=2.0.2.0
CIDER_CI_DIR=/tmp/cider-ci

################################################################################
### Cider-CI Quick Install ####################################################
###############################################################################

### examples ##################################################################
#
# curl https://raw.githubusercontent.com/cider-ci/cider-ci_deploy/master/bin/quick-install.sh | bash
#
# curl https://raw.githubusercontent.com/cider-ci/cider-ci_deploy/master/bin/quick-install.sh | bash -s 'v4'
#

if [ -z ${1-} ]; then
  VERSION='v4'
else
  VERSION=${1-}
fi

echo $VERSION

### check if we are root ######################################################

if [ "$UID" != "0" ]; then
   echo 'Cider-CI "Quick Install" must be run as root.' 1>&2
   exit -1
fi


###############################################################################
### prepare the system ########################################################
###############################################################################

### get the system up-to date so dependencies resolve without problems ########

apt-get update
apt-get dist-upgrade -y -f


### install git ###############################################################

apt-get install -y git


### install Ansible ###########################################################

apt-get install python2.7 python2.7-dev python-pip git libffi-dev -y -f
pip install -I --upgrade pip
pip install -I --upgrade paramiko==1.17.0 ansible==${ANSIBLE_VERSION}

###############################################################################
### checkout ##################################################################
###############################################################################

cd /tmp

rm -rf "${CIDER_CI_DIR}"
git clone --no-checkout https://github.com/cider-ci/cider-ci "${CIDER_CI_DIR}"
cd "${CIDER_CI_DIR}"
git checkout "${VERSION}"
git submodule update --init --recursive deploy


###############################################################################
### deploy ####################################################################
###############################################################################

cd "${CIDER_CI_DIR}/deploy"
ansible-playbook -i inventories/demo/hosts deploy_play.yml
