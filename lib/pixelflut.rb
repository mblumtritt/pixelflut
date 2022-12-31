# frozen_string_literal: true

require_relative 'pixelflut/sender'
require_relative 'pixelflut/image'

module Pixelflut
  class << self
    def slices(source:, x: 0, y: 0, scale: nil, mode: :rgbx, slices:)
      i = -1
      pixels(as_image(source, scale), x, y, as_cvt(mode))
        .shuffle!
        .group_by { (i += 1) % slices }
        .transform_values!(&:join)
        .values
    end

    private

    def pixels(image, dx, dy, cvt)
      image.converted do |x, y, px|
        "PX #{x + dx} #{y + dy} #{cvt[px]}\n" if 0 != px.alpha
      end
    end

    def as_image(source, scale)
      image = Image.new(source)
      scale ? image.scale(scale) : image
    end

    def as_cvt(mode)
      case mode
      when :rgb, 'rgb'
        ->(px) { px.to_color(Magick::AllCompliance, false, 8, true)[1, 6] }
      when :rgba, 'rgba'
        ->(px) { px.to_color(Magick::AllCompliance, true, 8, true)[1, 8] }
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
