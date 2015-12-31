#!/usr/bin/env bash
set -ex

###############################################################################
### Cider-CI Quick Install ####################################################
###############################################################################

### examples ##################################################################
#
# curl https://raw.githubusercontent.com/cider-ci/cider-ci_deploy/master/bin/quick-install.sh | bash
#
# curl https://raw.githubusercontent.com/cider-ci/cider-ci_deploy/master/bin/quick-install.sh | bash -s '3.11.0'
#

### check if we are root ######################################################

if [ "$UID" != "0" ]; then
   echo 'Cider-CI "Quick Install" must be run as root and not via sudo' 1>&2
   exit 1
fi


###############################################################################
### prepare the system ########################################################
###############################################################################

### get the system up-to date so dependencies resolve without problems ########

apt-get update
apt-get dist-upgrade -y -f


### setup ssh #################################################################

apt-get install openssh-server -y -f

if [ ! -e ~/.ssh/id_rsa.pub ]; then
  ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
fi
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
cp ~/.ssh/authorized_keys ~/.ssh/authorized_keys.bk
cat ~/.ssh/authorized_keys.bk | uniq > ~/.ssh/authorized_keys


### install Ansible ###########################################################

apt-get install python2.7 python2.7-dev python-pip git -y -f
pip install -I ansible==1.9.4


###############################################################################
### run deploy ################################################################
###############################################################################

rm -rf cider-ci
git clone -b master https://github.com/cider-ci/cider-ci.git --recursive
cd cider-ci/deploy

### switch to explicit ref if given ###########################################
if [ -n "$1" ]; then
  git fetch --all
  git reset --hard "$1" --
  git submodule update --init --recursive
fi

DEPLOY_ROOT_DIR=`pwd` ansible-playbook -i inventories/demo/simple/hosts play_site.yml
