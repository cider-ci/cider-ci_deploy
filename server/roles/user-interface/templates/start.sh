#!/bin/bash
set -x
source /etc/profile.d/rbenv-load.sh
cd {{ui_root_path}}
rbenv-load
rbenv shell {{rubies.jruby.version}}

# Rails Settings
export RAILS_ENV={{rails_env}}
export RAILS_RELATIVE_URL_ROOT={{web_sub_path}}{{web_ui_prefix}}
export CACHE_STORE_SIZE_MB={{ user_interface_cache_store_size_megabytes }}

# Memory Settings
export JRUBY_OPTS="-J-Xmx{{user_interface_xmx_mb_value}}m"

bundle exec puma config.ru -t 4:40 -b tcp://127.0.0.1:8880 \
  >> {{user_interface_log_dir}}/console.log 2>&1
