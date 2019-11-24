require 'rmagick'

module Pixelflut
  class Image
    def initialize(file_name)
      @image = Magick::ImageList.new(file_name)[0]
    rescue Magick::ImageMagickError => e
      raise(LoadError, e.message, cause: e)
    end

    def width
      @image.columns
    end

    def height
      @image.rows
    end

    def resize_to(width, height = nil)
      @image.resize_to_fit!(width, height)
    end

    def scale(factor)
      @image.scale!(factor)
    end

    def each_pixel
      return to_enum(__method__) unless block_given?
      @image.each_pixel{ |px, x, y| 0 != px.alpha and yield(x, y, px) }
    end
  end
end
