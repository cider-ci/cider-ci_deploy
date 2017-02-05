#!/usr/bin/env ruby

require 'yaml'
require 'open3'
require 'pry'
require 'active_support/all'
require 'fileutils'

APP_NAME='cider-ci'
LEIN_SERVICES= %w(executor server)
RAILS_SERVICES= %w(user-interface)

DEPLOY_DIR= Pathname.new(File.dirname(File.absolute_path(__FILE__))).join("..").to_s
SOURCE_DIR= File.absolute_path("#{DEPLOY_DIR}/..")
CONFIG_DIR= File.absolute_path("#{SOURCE_DIR}/config")
BUILD_DIR= File.absolute_path("#{DEPLOY_DIR}/tmp/#{APP_NAME}")
BUILD_CONFIG_DIR= File.absolute_path("#{BUILD_DIR}/config")

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

def clean
  FileUtils.rm_r BUILD_DIR, :force => true
  FileUtils.rm_r "#{CONFIG_DIR}/deploy-info.yml", :force => true
end

def tree_id
  tree_id= Dir.chdir(SOURCE_DIR) do
    exec!("git log -1 --pretty=%t").strip
  end
end

def commit_id
  tree_id= Dir.chdir(SOURCE_DIR) do
    exec!("git log -1 --pretty=%H").strip
  end
end

def deploy_info
  { tree_id: tree_id,
    commit_id: commit_id,
    time: Time.now.utc.to_json }
end

def releases
  release = YAML.load_file("../config/releases.yml").
    with_indifferent_access[:releases][0]
  release[:version_build] = tree_id
  {'releases' => [release]}
end

def prepare
  clean
  FileUtils.mkdir_p BUILD_DIR
  IO.write("#{BUILD_DIR}/tree_id",tree_id)
  IO.write("#{SOURCE_DIR}/config/deploy-info.yml", deploy_info.as_json.to_yaml)
  print " prepared, ..."
end

def build_config_dir
  print "building config dir ... "
  FileUtils.mkdir_p BUILD_CONFIG_DIR
  FileUtils.cp "#{CONFIG_DIR}/config_default.yml", BUILD_CONFIG_DIR
  IO.write "#{BUILD_CONFIG_DIR}/releases.yml", releases.to_yaml
  IO.write "#{BUILD_CONFIG_DIR}/deploy-info.yml", deploy_info.as_json.to_yaml
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
  print "building documentation ... "
  copy_git_repo_files 'documentation'
  print "done, "
end

def build_rails_services
  RAILS_SERVICES.each do |service|
    print "building #{service} ... "
    copy_git_repo_files service
    print "done, "
  end
end

def build_lein_service service_name
  print "building #{service_name} ... "
  service_source_dir = "#{SOURCE_DIR}/#{service_name}"
  service_target_dir = "#{BUILD_DIR}/#{service_name}"
  FileUtils.mkdir_p service_target_dir
  exec! <<-CMD.strip_heredoc
    #!/usr/bin/env bash
    unset JAVA_OPTS
    unset JAVA_ARCH
    export LEIN_ROOT=1
    export LEIN_SNAPSHOTS_IN_RELEASE=yes
    set -eux
    cd #{service_source_dir}
    #{DEPLOY_DIR}/bin/lein do clean, uberjar
  CMD
 FileUtils.cp "#{service_source_dir}/target/#{service_name}.jar",
   "#{service_target_dir}/#{service_name}.jar"
  print "done, "
end

def build_lein_services
  exec! <<-CMD.strip_heredoc
    cd #{SOURCE_DIR}/lein-dev-plugin
    #{DEPLOY_DIR}/bin/lein install
  CMD
  LEIN_SERVICES.each do |lein_service|
    build_lein_service lein_service
  end
end

def build_downloads
  print "building downloads ... "
  FileUtils.mkdir_p "#{BUILD_DIR}/downloads"
  exec! <<-CMD.strip_heredoc
    #!/usr/bin/env bash
    set -eux
    cd #{BUILD_DIR}/downloads
    ln  -s ../executor/ executor
  CMD
  print "done, "
end

def pack build_archive
  print "pack archive ... "
  exec! <<-CMD.strip_heredoc
    #!/usr/bin/env bash
    set -eux
    cd #{BUILD_DIR}
    cd ..
    tar cfz #{DEPLOY_DIR}/#{build_archive} #{APP_NAME}
  CMD
  print "done, "
end

def archive_is_up_to_date
  clean
  begin
    exec! "tar xvfz #{APP_NAME}.tar.gz -C tmp #{APP_NAME}/tree_id"
    IO.read("#{BUILD_DIR}/tree_id") == tree_id
  rescue Exception => e
    nil
  end
end

def main
  begin
    build_archive = "#{APP_NAME}.tar.gz"
    clean
    if archive_is_up_to_date
      print "existing archive #{build_archive} is up to date"
    else
      print "building #{build_archive} ..."
      prepare
      build_config_dir
      build_documentation_dir
      build_rails_services
      build_lein_services
      build_downloads
      pack build_archive
      puts " done "
    end
  ensure
    clean
  end
end

main()
