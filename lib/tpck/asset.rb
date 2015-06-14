require "mime/types"

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

    def mtime
      @attributes["mtime"]
    end

    def mime_type
      @attributes["mime_type"]
    end

    def body
      Util.decode(@attributes["encoded_body"])
    end

    def self.open(path)
      body = File.binread(path)

      Asset.new({
        "path" => path,
        "encoded_body" => Util.encode(body),
        "hexdigest" => Util.hexdigest(path),
        "mtime" => File.mtime(path),
        "mime_type" => MIME::Types.type_for(path).first.to_s,
      })
    end

    def to_h
      {
        "path" => path,
        "encoded_body" => encoded_body,
        "hexdigest" => hexdigest,
        "mtime" => mtime,
        "mime_type" => mime_type,
      }
    end
  end
end
