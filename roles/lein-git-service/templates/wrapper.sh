#!/bin/bash
mkdir -p {{lein_git_service_log_dir}}
chown -R {{lein_git_service_user}} {{lein_git_service_log_dir}}
sudo -u {{lein_git_service_user}} -n -i {{lein_git_service_bin}}
