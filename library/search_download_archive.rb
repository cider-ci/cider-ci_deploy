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
cider_ci_url = "http://ci.zhdk.ch/cider-ci/storage/tree-attachments/#{tree_id}/cider-ci.tar.gz"

def check_url! url
  begin
    exec! " curl -sS --fail -I '#{url}'"
    url
  rescue Exception => e
    nil
  end
end

args = JSON.parse(File.open(ARGV[0]).read) rescue {}

print JSON.dump(
  "changed" => false,
  "url" => check_url!("http://ci.zhdk.ch/cider-ci/storage/tree-attachments/#{tree_id}/cider-ci.tar.gz"),
  "stdout" => "OK"
)

exit 0
