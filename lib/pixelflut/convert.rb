require 'rmagick'

module Pixelflut
  module Convert
    def self.random_slices(image, dx, dy, mode, count)
      mode = MODE.fetch(mode)
      ret, idx = Array.new(count) { [] }, 0
      image.each_pixel.to_a.shuffle!.each do |x, y, px|
        ret[idx % count] << "PX #{x + dx} #{y + dy} #{mode.call(px)}\n"
        idx += 1
      end
      ret
    end

    MODE = {
      rgb: lambda do |pixel|
        pixel.to_color(Magick::AllCompliance, false, 8, true)[1, 6]
      end,
      rgba: lambda do |pixel|
        pixel.to_color(Magick::AllCompliance, true, 8, true)[1, 8]
      end,
      rgbx: lambda do |pixel|
        pixel.to_color(Magick::AllCompliance, false, 8, true)[
          1,
          pixel.alpha >= 65_535 ? 6 : 8
        ]
      end
    }.freeze
  end
end
