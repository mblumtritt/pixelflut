# frozen_string_literal: true

require 'rmagick'

module Pixelflut
  class Image
    def initialize(file_name)
      @image = Magick::ImageList.new(file_name).first
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
      self
    end

    def scale(factor)
      @image.scale!(factor)
      self
    end

    def converted
      c = @image.columns
      r = @image.rows
      n = -1
      @image
        .get_pixels(0, 0, c, r)
        .filter_map do |px|
          n += 1
          yield(n % c, n / r, px)
        end
    end
  end
end
