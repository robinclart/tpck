require "fileutils"
require "json"
require "zlib"

require "tpck/util"
require "tpck/asset"
require "tpck/error"

module Tpck
  class Package
    def initialize(io, data = nil)
      @io = io
      @data = data
    end

    def self.open(path, mode)
      rw = case mode
      when :writer then Zlib::GzipWriter.open(path)
      when :reader then Zlib::GzipReader.open(path)
      else raise Error
      end

      package = Package.new(rw)

      if block_given?
        yield package
        package.close unless package.closed?
      end

      package
    end

    def close
      @io.close
    end

    def closed?
      @io.closed?
    end

    def read
      JSON.parse(@io.read)
    end

    def write(data = {})
      @io.write(JSON.generate(data))
    end

    def assets
      @assets ||= read["assets"].map { |a| Asset.new(a) }
    end

    def unpack
      assets.each do |asset|
        FileUtils.mkdir_p(asset.dirname)
        File.open(asset.path, "w+") do |f|
          f.write asset.body
        end
      end
    end
  end
end
