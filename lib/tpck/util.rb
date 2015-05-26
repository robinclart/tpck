require "base64"
require "openssl"

module Util
  module_function

  def encode(src)
    Base64.encode64(src)
  end

  def decode(src)
    Base64.decode64(src)
  end

  def hexdigest(path)
    OpenSSL::Digest::SHA1.file(path).hexdigest
  end
end
