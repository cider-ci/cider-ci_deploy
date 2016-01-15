#!/bin/bash
mkdir -p {{lein_service_log_dir}}
chown -R {{lein_service_user}} {{lein_service_log_dir}}
sudo -u {{lein_service_user}} -n -i {{lein_service_bin}}
#su {{lein_service_user}} -c {{lein_service_bin}}
