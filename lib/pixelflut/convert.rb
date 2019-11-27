require 'rmagick'

module Pixelflut
  module Convert
    MODE = {
      rgb: lambda do |pixel|
        pixel.to_color(Magick::AllCompliance, false, 8, true)[1, 6]
      end,
      rgba: lambda do |pixel|
        pixel.to_color(Magick::AllCompliance, true, 8, true)[1, 8]
      end,
      rgbx: lambda do |pixel|
        if pixel.alpha >= 65535
          pixel.to_color(Magick::AllCompliance, false, 8, true)[1, 6]
        else
          pixel.to_color(Magick::AllCompliance, true, 8, true)[1, 8]
        end
      end
    }.freeze

    def self.each_line(image, dx, dy, mode)
      return to_enum(__method__, image, dx, dy, mode) unless block_given?
      mode = MODE.fetch(mode) if Symbol === mode
      image.each_pixel do |x, y, px|
        yield("PX #{x + dx} #{y + dy} #{mode.call(px)}\n")
      end
    end

    def self.as_slices(image, dx, dy, mode, count)
      ret = each_line(image, dx, dy, mode).to_a.shuffle!
      ret = ret.each_slice(ret.size / (count + 1)).to_a
      rest = ret.pop
      i = 0
      rest.each do |line|
        ret[i] << line
        i = 0 if (i+= 1) == ret.size
      end
      ret
    end
  end
end
