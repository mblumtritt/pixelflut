# frozen_string_literal: true

module Pixelflut
  class TextImage
    attr_reader :columns, :rows, :to_blob, :changes

    def initialize(width, height)
      @columns, @rows = width, height
      @row_inc = width * 4
      clear
    end

    alias width columns
    alias height rows

    def clear
      @to_blob = Black * (@columns * @rows)
      @changes = 1
    end

    def changed
      @changes = 0
      self
    end

    # def [](x, y)
    #   @data[(4 * (x + @columns * y)) % @data.size, 4].bytes.map! do |b|
    #     b = b.to_s(16)
    #     b = '0' + b if b.size == 1
    #     b
    #   end.join
    # end

    def []=(x, y, rrggbbaa)
      @to_blob[(4 * (x + @columns * y)) % @to_blob.size, 4] = as_color(rrggbbaa)
      @changes += 1
    end

    def draw_rect(x1, y1, x2, y2, rrggbbaa)
      x1, x2 = x2, x1 if x1 > x2
      y1, y2 = y2, y1 if y1 > y2
      color = as_color(rrggbbaa)
      pos = (4 * (x1 + @columns * y1)) % @data.size
      pattern = color * (x2 - x1 + 1)
      (y2 - y1 + 1).times do
        @data[pos, pattern.size] = pattern
        pos += @row_inc
      end
      @changes += 1
    end

    private

    ZZ = 0.chr.freeze
    FF = 0xff.chr.freeze
    Black = (ZZ + ZZ + ZZ + FF).freeze

    def as_color(rrggbbaa)
      case rrggbbaa.size
      when 3 # RGB
        (rrggbbaa[0] * 2).to_i(16).chr +
        (rrggbbaa[1] * 2).to_i(16).chr +
        (rrggbbaa[2] * 2).to_i(16).chr +
        FF
      when 4 # RGBA
        (rrggbbaa[0] * 2).to_i(16).chr +
        (rrggbbaa[1] * 2).to_i(16).chr +
        (rrggbbaa[2] * 2).to_i(16).chr +
        (rrggbbaa[3] * 2).to_i(16).chr
      when 6 # RRGGBB
        (rrggbbaa[0, 2]).to_i(16).chr +
        (rrggbbaa[2, 2]).to_i(16).chr +
        (rrggbbaa[4, 2]).to_i(16).chr +
        FF
      when 8 # RRGGBBAA
        (rrggbbaa[0, 2]).to_i(16).chr +
        (rrggbbaa[2, 2]).to_i(16).chr +
        (rrggbbaa[4, 2]).to_i(16).chr +
        (rrggbbaa[6, 2]).to_i(16).chr
      else
        Black
      end
    end

    # def pos(x, y)
    #   (4 * (x + @columns * y)) % @data.size
    # end
  end
end
