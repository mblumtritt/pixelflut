# frozen_string_literal: true

require_relative 'pixelflut/image'
require_relative 'pixelflut/convert'
require_relative 'pixelflut/sender'

module Pixelflut
  def self.sliced(source:, count: 4, x: 0, y: 0, scale: nil, mode: :rgbx)
    image = Image.new(source)
    image.scale(scale) if scale
    Convert.random_slices(image, x, y, mode, count)
  end
end
