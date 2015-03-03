require "fileutils"

require "tpck/util"
require "tpck/asset"
require "tpck/error"
require "tpck/reader"
require "tpck/writer"

module Tpck
  class Package
    def initialize(io, data = nil)
      @io = io
      @data = data
    end

    def self.open(path, mode = :reader)
      wr = case mode
      when :reader then Reader.open(path)
      when :writer then Writer.open(path)
      else
        raise Error
      end

      package = Package.new(wr)

      if block_given?
        yield package
        package.close unless package.closed?
      end

      Package.new(wr)
    end

    def close
      @io.close
    end

    def closed?
      @io.closed?
    end

    def read
      @data ||= begin
        @io.rewind
        data = Util.read_json(@io)
        @io.close
        data
      end
    end

    def write(data = {})
      @data ||= data
      Util.write_json(@data, @io)
      @io.close
      @data
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
