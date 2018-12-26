# frozen_string_literal: true

module Pixelflut
  module Canvas
    class Base
      attr_accessor :offset_x, :offset_y

      def initialize
        clear!
      end

      def clear!
        @offset_x = @offset_y = 0
        @color = 'ffffffff'
      end

      def translate(x, y)
        ox, oy = @offset_x, @offset_y
        @offset_x += x
        @offset_y += y
        yield
      ensure
        @offset_x, @offset_y = ox, oy
      end

      def color(color)
        oc = @color
        @color = color
        yield
      ensure
        @color = oc
      end

      def []=(x, y, color)
        out("PX #{x(x)} #{y(y)} #{color}\n")
      end

      def pix(x, y, color = @color)
        out("PX #{x(x)} #{y(y)} #{color}\n")
      end

      def rect(x1, y1, x2, y2, color = @color)
        out("RC #{x(x1)} #{y(y1)} #{x(x2)} #{y(y2)} #{color}\n")
      end

      def line(x1, y1, x2, y2, color = @color)
        return rect(x1, y1, x2, y2, color) if x1 == x2 || y1 == y2
        x, y, curpixel = x1, y1, 0
        deltax = (x2 - x1).abs
        deltay = (y2 - y1).abs
        xinc1 = xinc2 = x2 >= x1 ? 1 : -1
        yinc1 = yinc2 = y2 >= y1 ? 1 : -1
        if deltax >= deltay
          xinc1 = yinc2 = 0
          den, numadd, numpixels, num = deltax, deltay, deltax, deltax / 2
        else
          xinc2 = yinc1 = 0
          den, numadd, numpixels, num = deltay, deltax, deltay, deltay / 2
        end
        while curpixel <= numpixels
          num += numadd
          if num >= den
            num -= den
            x += xinc1
            y += yinc1
          end
          x += xinc2
          y += yinc2
          pix(x, y, color)
          curpixel += 1
        end
      end

      def ascii(x, y, dim = 10, color = @color, pic = nil)
        pic ||= yield
        sx = x
        pic.each_line do |line|
          line.chomp!
          line.each_char do |c|
            rect(x, y, x + dim, y + dim, color) if ' ' != c && '_' != c
            x += dim
          end
          x = sx
          y += dim
        end
      end

      protected

      def x(x)
        x + @offset_x
      end

      def y(y)
        y + @offset_y
      end
    end
  end
end
