#!/usr/bin/ruby
#
# passgen.rb - simple password generator
#
# How to use:
#   $ echo login.password.google.com | ./passgen.rb
#
# GitHub:
#   https://github.com/yoggy/passgen.rb
#
# License:
#   Copyright (c) 2016 yoggy <yoggy0@gmail.com>
#   Released under the MIT license
#   http://opensource.org/licenses/mit-license.php;
#
require 'openssl'
require 'base64'
require 'optparse'

secret_key = `hostname -s`
len = 12
encode_char = "0123456789abcdefghijkmnpqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!#$%-=+*@"

OptionParser.new do |opt|
  opt.on('-l', '--length=VALUE', 'hash string length')  {|v| len = v.to_i}
  opt.on('-s', '--secret_key=VALUE', 'secret key')      {|v| secret_key = v}
  opt.on('-e', '--encode_char=VALUE', 'encode char')    {|v| encode_char=v}

  opt.parse!(ARGV)
end

s = $stdin.read()
s.chomp()
sha256 = OpenSSL::HMAC.digest('sha256', secret_key, s)

total = 0
sha256.bytes do |b|
  total = total * 256
  total += b
end

encode_str = ""
((Math.log(total, encode_char.size)+1).floor).times do
  i = total % encode_char.size
  encode_str << encode_char[i]
  total = total / encode_char.size
end

if encode_str.size > len
  encode_str = encode_str[0, len]
end

puts encode_str

