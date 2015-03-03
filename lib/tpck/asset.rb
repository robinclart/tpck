require "tpck/util"

module Tpck
  class Asset
    def initialize(attributes = {})
      @attributes = attributes
    end

    def dirname
      File.dirname(path)
    end

    def path
      @attributes["path"]
    end

    def hexdigest
      @attributes["hexdigest"]
    end

    def encoded_body
      @attributes["encoded_body"]
    end

    def body
      Util.decode(@attributes["encoded_body"])
    end

    def self.open(path)
      body = File.read(path)

      Asset.new({
        "path" => path,
        "encoded_body" => Util.encode(body),
        "hexdigest" => Util.hexdigest(path)
      })
    end

    def to_h
      {
        "path" => path,
        "encoded_body" => encoded_body,
        "hexdigest" => hexdigest
      }
    end
  end
end
