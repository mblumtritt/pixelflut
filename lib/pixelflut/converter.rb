# frozen_string_literal: true

module Pixelflut
  class Converter
    Error = Class.new(RuntimeError)
  end

  begin
    require 'rmagick'

    class Converter
      Avail = true
      attr_accessor :x_offset, :y_offset

      def initialize(file_name)
        @images = load_images(file_name)
        @x_offset = @y_offset = 0
      end

      def resize_to(width, height = nil)
        @images.each{ |image| image.resize_to_fit!(width, height) }
      end

      def each_pixel
        return to_enum(__method__) unless block_given?
        @images.each do |image|
          image.each_pixel do |color, x, y|
            yield(
              x + @x_offset,
              y + @y_offset,
              color.to_color(Magick::AllCompliance, true, 8, true)[1, 8]
            ) unless 0xffff == color.opacity
          end
        end
      end

      def each_line
        return to_enum(__method__) unless block_given?
        each_pixel{ |x, y, rgba| yield "PX #{x} #{y} #{rgba}" }
      end

      private

      def load_images(file_name)
        Magick::ImageList.new(file_name)
      rescue Magick::ImageMagickError => e
        raise(Error, e.message)
      end
    end
  rescue LoadError
    Converter::Avail = false
  end
end
