require "pathname"

require "tpck/asset"
require "tpck/error"
require "tpck/package"

module Tpck
  class Theme
    def initialize(dir, assets)
      @dir = dir
      @assets = assets
    end

    def self.open(path)
      if File.extname(path) == "tpck"
        package = Package.open(path, :reader)
        asset = package.read["assets"].map { |a| Asset.new(a) }
        new(File.basename(path), assets)
      else
        dir = Pathname.new(path.to_s)
        assets = Dir.glob(dir.join("**", "*.*")).map { |p| Asset.open(p) }
        new(dir, assets)
      end
    end

    def pack
      Package.open "#{@dir}.tpck", :writer do |p|
        p.write({ "assets" => @assets.map(&:to_h) })
      end
    end

    def unpack
      @assets.each do |asset|
        FileUtils.mkdir_p(asset.dirname)
        File.open(asset.path, "wb") do |f|
          f.write asset.body
        end
      end
    end
  end
end
