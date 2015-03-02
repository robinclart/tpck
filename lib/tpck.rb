require "pathname"
require "base64"
require "json"
require "fileutils"
require "zlib"

require "tpck/version"

module Tpck
  Error = Class.new(StandardError)

  class Directory
    def initialize(dir)
      @dir = Pathname.new(dir.to_s)
      raise Error unless @dir.directory?
    end

    def files
      @files ||= glob.map { |p| [p, Util.encode_file(p)] }
    end

    def encode
      Hash[files].to_json
    end

    def glob
      Dir.glob(@dir.join("**", "*.*"))
    end

    def pack
      File.open("#{@dir.to_s}.tpck", "wb") do |f|
        gz = Zlib::GzipWriter.new(f)
        gz.write(encode)
        gz.close
      end
    end
  end

  class Package
    def initialize(content)
      @content = content
    end

    def self.read(path)
      buffer = ""

      File.open(path.to_s, "rb") do |f|
        gz = begin
          Zlib::GzipReader.new(f)
        rescue Errno::EISDIR
          raise Error
        rescue Zlib::GzipFile::Error
          raise Error
        end
        buffer << gz.read
        gz.close
      end

      new(buffer)
    end

    def load
      JSON.load(@content)
    end

    def decode
      decoded = load.map do |path,content|
        [path, Base64.decode64(content)]
      end
      Hash[decoded]
    end

    def unpack
      decode.each do |path,content|
        FileUtils.mkdir_p(Pathname.new(path).dirname)
        File.open(path, "w+") do |f|
          f.write content
        end
      end
    end
  end

  module Util
    module_function

    def encode_file(path)
      Base64.encode64(File.read(path))
    end
  end
end
