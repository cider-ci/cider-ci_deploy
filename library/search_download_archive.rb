#!/usr/bin/env ruby
# WANT_JSON

require 'json'
require 'openssl'
require 'open3'
require 'yaml'

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

def tag
  release = YAML.load_file("../config/releases.yml")['releases'].first
  tag = "#{release['version_major']}.#{release['version_minor']}.#{release['version_patch']}" \
    + ( release['version_pre'] ?  "-#{release['version_pre']}" : "")
end

@tag = tag
@tree_id = exec!('cd .. && git log -n 1 --pretty=%T').strip

def check_url! url
  exec! " curl -sS --fail -I '#{url}'"
end

def check_and_build_urls base_url
  begin
    ['cider-ci.tar.gz', 'cider-ci.tar.gz.sig'].map{|name|
      base_url + "/" + name
    }.map{ |url|
      check_url!(url) && url
    }
  rescue Exception => e
    nil
  end
end

def find_urls
  check_and_build_urls("https://github.com/cider-ci/cider-ci/releases/download/#{@tag}") \
  || check_and_build_urls("http://ci.zhdk.ch/cider-ci/storage/tree-attachments/#{@tree_id}")
end


args = JSON.parse(File.open(ARGV[0]).read) rescue {}

begin
  print JSON.dump(
    "changed" => false,
    "urls" => find_urls,
    "stdout" => "Archive and signature found."
  )
rescue Exception => e
  print JSON.dump(
    "changed" => false,
    "urls" => nil,
    "stdout" => "Warning: archive or signature missing! #{e}"
  )
end

exit 0
