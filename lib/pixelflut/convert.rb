module Pixelflut
  module Convert
    def self.each_line0(image)
      return to_enum(__method__, image) unless block_given?
      image.each_pixel do |x, y, px|
        px = px.to_color(Magick::AllCompliance, true, 8, true)[
          1, 255 == px.alpha ? 6 : 8
        ]
        yield("PX #{x} #{y} #{px}\n")
      end
    end

    def self.each_line(image, dx, dy)
      return to_enum(__method__, image, dx, dy) unless block_given?
      image.each_pixel do |x, y, px|
        px = px.to_color(Magick::AllCompliance, true, 8, true)[
          1, 255 == px.alpha ? 6 : 8
        ]
        yield("PX #{x + dx} #{y + dy} #{px}\n")
      end
    end

    def self.as_slices(image, dx, dy, count)
      ret = each_line(image, dx, dy).to_a.shuffle!
      ret.each_slice(ret.size / count).to_a
    end
  end
end
