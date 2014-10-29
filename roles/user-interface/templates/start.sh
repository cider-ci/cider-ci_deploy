#!/bin/bash
source /etc/profile.d/rbenv-load.sh \
&& cd {{ui_root_path}} \
&& rbenv-load \
&& rbenv shell {{rubies.jruby.version}} \
&& export JVM_OPTS="-Xmx{{user_interface_xmx_value}}" \
&& export RAILS_ENV={{rails_env}}  \
&& export RAILS_RELATIVE_URL_ROOT={{web_sub_path}}{{web_ui_prefix}} \
&& bundle exec puma config.ru -t 4:40 -b tcp://127.0.0.1:8880 \
  >> {{user_interface_log_dir}}/{{user_interface_service_name}}.log 2>&1
