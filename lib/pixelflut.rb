# frozen_string_literal: true

require_relative 'pixelflut/image'
require_relative 'pixelflut/convert'
require_relative 'pixelflut/sender'

module Pixelflut
  def self.converted(source, x = 0, y = 0, scale = nil)
    image = Image.new(source)
    image.scale(scale) if scale
    Convert.each_line(image, x, y)
  end

  def self.as_slices(source:, count: 4, x: 0, y: 0, scale: nil)
    image = Image.new(source)
    image.scale(scale) if scale
    Convert.as_slices(image, x, y, count)
  end
end
