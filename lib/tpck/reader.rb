require "zlib"

module Tpck
  class Reader
    def initialize(file)
      @reader = Zlib::GzipReader.new(file)
    end

    def self.open(path)
      file = File.open(path, "rb")
      reader = self.class.new(file)

      if block_given?
        yield reader
        reader.close
      end

      reader
    end

    def rewind
      @reader.rewind
    end

    def read
      @reader.read
    end

    def close
      @reader.close
    end

    def closed?
      @reader.closed?
    end
  end
end
