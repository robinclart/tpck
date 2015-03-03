require "pathname"

require "tpck/asset"
require "tpck/error"
require "tpck/package"

module Tpck
  class Theme
    def initialize(path)
      @dir = Pathname.new(path.to_s)
      raise Error unless @dir.directory?
    end

    def glob
      Dir.glob(@dir.join("**", "*.*"))
    end

    def assets
      @assets ||= glob.map { |p| Asset.open(p) }
    end

    def to_h
      {
        "assets" => assets.map(&:to_h)
      }
    end

    def pack
      Package.open "#{@dir}.tpck", :writer do |p|
        p.write(to_h)
      end
    end
  end
end
