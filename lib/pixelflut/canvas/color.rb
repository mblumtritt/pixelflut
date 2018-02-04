module Pixelflut
  module Canvas
    class Base
      module Color
        class << self
          def from_rgb(r, g, b)
            from_rgba(r, g, b, 0xff)
          end

          def from_rgba(r, g, b, a)
            as_hex(r) + as_hex(g) + as_hex(b) + as_hex(a)
          end

          private

          def as_hex(int)
            ret = int.to_s(16)
            ret = '0' + ret if 1 == ret.size
            ret
          end
        end

        Black = from_rgba(0, 0, 0, 0xff)
        White = from_rgba(0xff, 0xff, 0xff, 0xff)
        Red = from_rgba(0xff, 0, 0, 0xff)
        Green = from_rgba(0, 0xff, 0, 0xff)
        Blue = from_rgba(0, 0, 0xff, 0xff)
        Yellow = from_rgba(0xff, 0xff, 0, 0xff)
      end
    end
  end
end
