# frozen_string_literal: true

module Pixelflut
  class Converter
    Error = Class.new(RuntimeError)
  end

  begin
    require 'rmagick'

    class Converter
      AVAIL = true

      def initialize(file_name)
        @images = load_images(file_name)
      end

      def resize_to(width, height = nil)
        @images.each{ |image| image.resize_to_fit!(width, height) }
      end

      def each_pixel
        return to_enum(__method__) unless block_given?
        @images.each do |image|
          image.each_pixel{ |color, x, y| yield(x, y, color) }
        end
      end

      def each_rgba_pixel
        return to_enum(__method__) unless block_given?
        each_pixel{ |x, y, color| yield(x, y, as_rgba(color)) unless 0xffff == color.opacity }
      end

      def draw(canvas)
        each_rgba_pixel{ |x, y, rgba| canvas[x, y] = rgba }
      end

      def as_rgba(color)
        color.to_color(Magick::AllCompliance, true, 8, true)[1, 8]
      end

      private

      def load_images(file_name)
        Magick::ImageList.new(file_name)
      rescue Magick::ImageMagickError => e
        raise(Error, e.message)
      end
    end
  rescue LoadError
    Converter::AVAIL = false
  end
end
