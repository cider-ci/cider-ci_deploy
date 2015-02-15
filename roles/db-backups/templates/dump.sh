#!/bin/bash

# Ansible managed 

bash << "EOF"
su -s /bin/bash -l {{user_interface_user}}

export RAILS_ENV={{rails_env}}
export DUMP_DIR="{{db_backups_dir}}"

export DUMP_FILE_NAME="{{item}}_{{rails_env}}_$(date +%FT%T%Z).pgbin"
export LINK_NAME="{{item}}_{{rails_env}}_latest.pgbin"

export DUMP_FILE="${DUMP_DIR}/${DUMP_FILE_NAME}"
export LINK="${DUMP_DIR}/${LINK_NAME}"

mkdir -p "${DUMP_DIR}"
rbenv-load && cd {{ui_root_path}} && bundle exec rake db:pg:{{item | replace("-","_")}}:dump FILE="$DUMP_FILE"
find ${DUMP_DIR} -name '*pgbin' -type f -mtime +10 -exec rm {} \;
cd ${DUMP_DIR} && ln -s -f ${DUMP_FILE_NAME} ${LINK_NAME}

EOF



