#!/usr/bin/ruby
# WANT_JSON

require 'json'
require 'yaml'
require 'fileutils'


FileUtils.mkdir_p '/etc/cider-ci'

def load_etc_traits
  YAML.load_file('/etc/cider-ci/traits.yml') rescue []
end


origial_traits = load_etc_traits

traits = origial_traits.dup

traits.reject!{ |t| t =~ /^ruby.*/}
ruby_version_arr = RUBY_VERSION.split('.')
traits << 'Ruby'
traits << "Ruby #{ruby_version_arr[0..1].join('.')}"

begin
  if system('bash', '-c', 'echo "Hello"')
    traits.reject!{ |t| t =~ /^bash.*/}
    traits << "Bash"
  end
rescue Exception => e
end

begin
  git_version= `git --version`.split(/\s+/).last
  traits.reject!{ |t| t =~ /^git.*/}
  version_arr = `git --version`.split(/\s+/).last.split('.')
  traits << "git"
  traits << "git #{version_arr.first}"
  traits << "git #{version_arr[0..1].join('.')}"
rescue Exception => e
end

traits.sort!.uniq!

IO.write '/etc/cider-ci/traits.yml', traits.to_yaml

print JSON.dump(
  "changed" => origial_traits != traits,
  "traits" => traits,
  "stdout" => "OK"
)
