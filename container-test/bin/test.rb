#!/usr/bin/env ruby

require 'hyperkit'
require 'active_support'
require 'pry'

lxd = Hyperkit::Client.new(api_endpoint: "https://#{ENV['LXC_API_ADDRESS']}", verify_ssl: false)
container = lxd.container ENV['CONTAINER_NAME']

#binding.pry
