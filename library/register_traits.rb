#!/usr/bin/env ruby
# WANT_JSON

require 'json'
require 'yaml'
require 'fileutils'


args = JSON.parse(File.open(ARGV[0]).read)
file = args['file']

def load_traits file
  YAML.load_file(file) rescue []
end

origial_traits = load_traits file

traits = origial_traits.dup


if (remove_match = args['remove_match'])
  regex = Regexp.new remove_match
  traits.reject!{|t| regex =~ t}
end

traits_argv = [].push *args['traits']

traits.concat traits_argv

traits.sort!.uniq!

IO.write file, traits.to_yaml

print JSON.dump(
  "file" => file,
  "traits_argv" => traits_argv,
  "changed" => origial_traits != traits,
  "origial_traits" => origial_traits,
  "traits" => traits,
  "stdout" => "OK"
)
