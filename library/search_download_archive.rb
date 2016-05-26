#!/usr/bin/env ruby
# WANT_JSON

require 'json'
require 'openssl'
require 'open3'

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

tree_id = exec!('cd .. && git log -n 1 --pretty=%T').strip

# TODO: for now we use what is found on cider-ci
# later on we want to use releases on GitHub (git tag --points-at HEAD)
# which are singed!
ci_url_prefix = "http://ci.zhdk.ch/cider-ci/storage/tree-attachments/#{tree_id}"

def check_url! url
  exec! " curl -sS --fail -I '#{url}'"
end

args = JSON.parse(File.open(ARGV[0]).read) rescue {}

begin
  check_url! "#{ci_url_prefix}/cider-ci.tar.gz"
  check_url! "#{ci_url_prefix}/cider-ci.tar.gz.sig"
  print JSON.dump(
    "changed" => false,
    "url_prefix" => ci_url_prefix,
    "stdout" => "Archive and signature found."
  )
rescue Exception => e
  print JSON.dump(
    "changed" => false,
    "stdout" => "Warning: archive or signature missing! #{e}"
  )
end

exit 0
