require "base64"
require "json"
require "openssl"

module Util
  module_function

  def encode(src)
    Base64.encode64(src)
  end

  def decode(src)
    Base64.decode64(src)
  end

  def write_json(src, io)
    JSON.dump(src, io)
  end

  def read_json(io)
    JSON.load(io)
  end

  def hexdigest(path)
    OpenSSL::Digest::SHA1.file(path).hexdigest
  end
end
