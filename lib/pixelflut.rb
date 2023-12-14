# frozen_string_literal: true

module Pixelflut
  class << self
    attr_accessor :file_name, :count, :mode, :delta_x, :delta_y

    def data
      sliced(convert(*load).shuffle!, @count).map!(&:join)
    end

    private

    def load
      require('chunky_png') unless defined?(ChunkyPNG)
      image = ChunkyPNG::Canvas.from_file(@file_name)
      [image.width, image.height, image.pixels.pack("N#{image.pixels.size}")]
    rescue Errno::ENOENT => e
      raise(LoadError, e.message, cause: e)
    end

    # def load_rmagick
    #   require('rmagick') unless defined?(Magick)
    #   image = Magick::Image.read(@file_name).first
    #   image.scale!(@scale) if @scale
    #   [
    #     image.columns,
    #     image.rows,
    #     image.export_pixels_to_str(0, 0, image.columns, image.rows, 'rgba')
    #   ]
    # rescue Magick::ImageMagickError => e
    #   raise(LoadError, e.message, cause: e)
    # end

    def sliced(array, number)
      division = array.size / number
      modulo = array.size % number
      pos = 0
      Array.new(number) do |index|
        length = division + (modulo > 0 && modulo > index ? 1 : 0)
        slice = array.slice(pos, length)
        pos += length
        slice
      end
    end

    def convert(width, height, blob)
      if @mode == 'bin'
        to_bin_format(width, height, blob)
      else
        to_text_format(width, height, blob)
      end
    end

    def to_text_format(width, height, blob)
      ret = []
      pos = -1
      height.times do |y|
        width.times do |x|
          next if (a = blob.getbyte(pos += 4)) == 0
          ret << format(
            (
              if a == 255
                "PX %d %d %02x%02x%02x\n"
              else
                "PX %d %d %02x%02x%02x%02x\n"
              end
            ),
            x + @delta_x,
            y + @delta_y,
            blob.getbyte(pos - 3),
            blob.getbyte(pos - 2),
            blob.getbyte(pos - 1),
            a
          )
        end
      end
      ret
    end

    def to_bin_format(width, height, blob)
      ret = []
      pos = 0
      height.times do |y|
        width.times do |x|
          if blob[pos + 3] != "\x0"
            ret << "PB#{[x + @delta_x, y + @delta_y].pack('v2')}#{blob[pos, 4]}"
          end
          pos += 4
        end
      end
      ret
    end
  end

  @count = ENV['TC'].to_i
  @count = 4 unless @count.positive?
  @mode = 'text'
  @delta_x = @delta_y = 0
end
