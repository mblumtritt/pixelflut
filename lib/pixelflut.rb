# frozen_string_literal: true

require_relative 'pixelflut/image'
require_relative 'pixelflut/sender'

module Pixelflut
  class << self
    def convert(source:, x: 0, y: 0, scale: nil, mode: :rgbx)
      _convert(as_image(source, scale), x, y, &as_cvt(mode))
    end

    def slices(lines, count: 4)
      Array.new(count) { [] }.tap do |ret|
        lines.each_with_index { |line, idx| ret[idx % count] << line }
      end
    end

    def junks(lines, bytes:)
      size, ret = 0, [current = []]
      lines.each do |line|
        next current << line if (size += line.bytesize) < bytes
        ret << (current = [line])
        size = line.bytesize
      end
      ret
    end
    alias packages junks # backward compatibility

    private

    def _convert(image, dx, dy)
      image.each_pixel.to_a.map! do |x, y, px|
        "PX #{x + dx} #{y + dy} #{yield(px)}\n"
      end.shuffle!
    end

    def as_image(source, scale)
      Image.new(source).tap { |image| image.scale(scale) if scale }
    end

    def as_cvt(mode)
      case mode
      when :rgb
        lambda { |px| px.to_color(Magick::AllCompliance, false, 8, true)[1, 6] }
      when :rgba
        lambda { |px| px.to_color(Magick::AllCompliance, true, 8, true)[1, 8] }
      else
        lambda do |px|
          px.to_color(Magick::AllCompliance, false, 8, true)[
            1,
            px.alpha >= 65_535 ? 6 : 8
          ]
        end
      end
    end
  end
end
