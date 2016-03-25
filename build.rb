#!/usr/bin/env ruby

require 'yaml'
require 'open3'
require 'pry'
require 'active_support/all'
require 'fileutils'

LEIN_SERVICES= %w(api builder dispatcher executor notifier repository storage)

DEPLOY_DIR= File.dirname(File.absolute_path(__FILE__))
SOURCE_DIR= File.absolute_path("#{DEPLOY_DIR}/..")
CONFIG_DIR= File.absolute_path("#{SOURCE_DIR}/config")
BUILD_DIR= File.absolute_path("#{DEPLOY_DIR}/tmp/cider-ci")
BUILD_CONFIG_DIR= File.absolute_path("#{BUILD_DIR}/config")

def exec! cmd
  Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
    exit_status = wait_thr.value
    unless exit_status.success?
      abort stderr.read
    else
      stdout.read
    end
  end
end

def release
  release = YAML.load_file("../config/releases.yml").
    with_indifferent_access[:releases][0]
  'Cider-CI' +
    ((edition = release[:edition].presence) ? "_#{edition}_" : "_").to_s +
    release[:version_major].to_s + "." +
    release[:version_minor].to_s + "." +
    release[:version_patch].to_s +
    ((pre=release[:version_pre].presence) ? "-#{pre}" : "") +
    ((build=release[:version_build].presence) ? "+#{build}" : "")
end

def prepare
  FileUtils.rm_r BUILD_DIR, :force => true
  FileUtils.mkdir_p BUILD_DIR
  print " prepared, ..."
end

def build_config_dir
  FileUtils.mkdir_p BUILD_CONFIG_DIR
  FileUtils.cp "#{CONFIG_DIR}/config_default.yml", BUILD_CONFIG_DIR
  FileUtils.cp "#{CONFIG_DIR}/releases.yml", BUILD_CONFIG_DIR
  print " config dir built, ..."
end

def copy_git_repo_files dir_name
  FileUtils.mkdir_p "#{BUILD_DIR}/#{dir_name}"
  sub_source_dir = "#{SOURCE_DIR}/#{dir_name}"
  Dir.exist?(sub_source_dir) || raise("No directory #{sub_source_dir}")
  exec! <<-CMD.strip_heredoc
    #!/usr/bin/env bash
    set -eux
    cd #{sub_source_dir}
    #{DEPLOY_DIR}/bin/git-archive-all -- - \
      | tar x --directory #{BUILD_DIR}/#{dir_name}
  CMD
end

def build_documentation_dir
  copy_git_repo_files "documentation"
  print " documentation built, ..."
end

def build_rails_services
  %w( user-interface ).each do |service|
    copy_git_repo_files service
    print " rails service #{service} built, ..."
  end
end

def build_lein_service service_name
  service_source_dir = "#{SOURCE_DIR}/#{service_name}"
  service_target_dir = "#{BUILD_DIR}/#{service_name}"
  FileUtils.mkdir_p service_target_dir
  exec! <<-CMD.strip_heredoc
    #!/usr/bin/env bash
    unset JAVA_OPTS
    unset JAVA_ARCH
    export LEIN_ROOT=1
    set -eux
    cd #{service_source_dir}
    #{DEPLOY_DIR}/bin/lein do clean, uberjar
  CMD
 FileUtils.cp "#{service_source_dir}/target/#{service_name}.jar",
   "#{service_target_dir}/#{service_name}.jar"
end

def build_lein_services
  LEIN_SERVICES.each do |lein_service|
    build_lein_service lein_service
    print " lein service #{lein_service} built, ... "
  end
end

def build_downloads
  FileUtils.mkdir_p "#{BUILD_DIR}/downloads"
  exec! <<-CMD.strip_heredoc
    #!/usr/bin/env bash
    set -eux
    cd #{BUILD_DIR}/downloads
    ln  -s ../executor/ executor
  CMD
  print " downloads prepared, ... "
end

def pack build_archive
  exec! <<-CMD.strip_heredoc
    #!/usr/bin/env bash
    set -eux
    cd #{BUILD_DIR}
    cd ..
    tar cfz #{DEPLOY_DIR}/#{build_archive} cider-ci
  CMD
  print "packed, ..."
end

def main
  build_archive = "#{release}.tar.gz"
  if File.exist? build_archive
    print "Build archive #{build_archive} exists, ..."
  else
    print "building #{build_archive} ..."
    prepare
    build_config_dir
    build_documentation_dir
    build_rails_services
    build_lein_services
    build_downloads
    pack build_archive
  end
  FileUtils.ln_s build_archive, "cider-ci.tar.gz", force: true
  print "linked, ..."
  puts " done "
end

# puts exec! "env | grep JAVA"
main()
