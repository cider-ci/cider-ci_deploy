#!/usr/bin/env ruby

require 'fileutils'
require 'open3'
require 'time'

RAILS_ROOT_DIR = '{{ci_db_backups_rails_root}}'
BACKUPDIR = '{{ci_db_backups_dir}}'

def exec! cmd
  Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
    stdin.close()
    out = stdout.read
    err = stderr.read
    exit_status = wait_thr.value
    unless exit_status.success?
      abort out + err
    else
      out
    end
  end
end

unless Dir.exist? RAILS_ROOT_DIR
  abort "The application dir seems not to exist."
end

exec! "/usr/sbin/logrotate -f /etc/logrotate.d/ci-db-backups"

%w(structure_and_data data).each do |scope|
  Dir.chdir RAILS_ROOT_DIR do
    exec! <<-BASH
      #!/bin/bash
      export JRUBY_HOME=#{RAILS_ROOT_DIR}/vendor/jruby
      export PATH=${JRUBY_HOME}/bin:$PATH
      export RAILS_ENV=production
      rm -f /tmp/backup.pgbin
      jruby -S bundle exec rake db:pg:#{scope}:dump FILE=/tmp/backup.pgbin
    BASH
  end
  file_name = "#{BACKUPDIR}/#{scope}.pgbin"
  FileUtils.mv "/tmp/backup.pgbin", file_name
end
