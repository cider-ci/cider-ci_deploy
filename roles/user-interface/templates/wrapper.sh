#!/bin/bash
mkdir -p {{user_interface_log_dir}}
chown -R {{user_interface_user}} {{user_interface_log_dir}}
sudo -u {{user_interface_user}} -n -i {{user_interface_service_bin}}
