require "zlib"

module Tpck
  class Writer
    def initialize(file)
      @writer = Zlib::GzipWriter.new(file)
    end

    def self.open(path)
      file = File.open(path, "wb")
      writer = self.class.new(file)

      if block_given?
        yield writer
        writer.close
      end

      writer
    end

    def rewind
      @writer.rewind
    end

    def write(src)
      @writer.write(src)
    end

    def close
      @writer.close
    end

    def closed?
      @writer.closed?
    end
  end
end
