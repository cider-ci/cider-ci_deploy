#!/usr/bin/ruby
# WANT_JSON

require 'json'
require 'openssl'

def signature(message, secret)
  OpenSSL::HMAC.hexdigest(
    OpenSSL::Digest.new('sha1'),
    secret, message)
end

args = JSON.parse(File.open(ARGV[0]).read)

print JSON.dump(
  "changed" => false,
  "signature" => signature(args['message'], args['secret']),
  "stdout" => "OK"
)

exit 0
