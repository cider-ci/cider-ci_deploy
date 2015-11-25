#!/bin/bash
set -eux
source /etc/profile.d/rbenv-load.sh
cd {{ui_root_path}}
rbenv-load
rbenv shell {{rubies.jruby.version}}

# Rails Settings
export RAILS_ENV={{rails_env}}
export RAILS_RELATIVE_URL_ROOT={{web_sub_path}}{{web_ui_prefix}}

# Memory Settings
export JVM_OPTS="-Xmx{{user_interface_xmx_value}}"
# it seems that the above is ignored,
# we could either invoke `jruby -J-Xmx4G` or set JRUBY_OPTS
export JRUBY_OPTS="-J-Xms{{user_interface_xms_value}}  -J-Xmx{{user_interface_xmx_value}}"

bundle exec puma config.ru -t 4:40 -b tcp://127.0.0.1:8880 \
  >> {{user_interface_log_dir}}/console.log 2>&1
