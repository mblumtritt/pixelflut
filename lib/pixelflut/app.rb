# frozen_string_literal: true

require 'gosu'
require_relative 'server'
require_relative 'text_image'

module Pixelflut
  class App < Gosu::Window
    Configuration = Struct.new(:width, :height, :fullscreen, :server) do
      def self.default
        new(nil, nil, false, Server::Configuration.default)
      end
    end

    def self.run(configuration = Configuration.default)
      new(configuration).show
    end

    def initialize(configuration)
      if configuration.fullscreen
        super(configuration.width || Gosu.screen_width, configuration.height || Gosu.screen_height, fullscreen: true)
      else
        super(configuration.width || 800, configuration.height || 600)
      end
      Process.setproctitle('pxflut')
      @image = TextImage.new(width, height)
      @server = Server.new(@image, configuration.server)
      log(self.caption = "Pixelflut@#{configuration.server.host}:#{configuration.server.port}")
      log(configuration.server)
      reset!
    end

    def show
      @server.run
      super
    end

    def reset!
      @image.clear
      log("clean image: #{@image.width}x#{@image.height}")
    end

    def update
      # self.caption = @image.changes
      @draw_image = nil unless 0 == @image.changes
    end

    def draw
      (@draw_image ||= Gosu::Image.new(@image.changed, tileable: true, retro: true)).draw(0, 0, 0)
    end

    def log(*args)
      print("[#{Time.now}] ")
      puts(*args)
    end

    def button_down(id)
      return close! if Gosu::Button::KbEscape == id
      return reset! if Gosu::Button::KbSpace == id
      return log("connections: #{@server.connection_count}") if Gosu::Button::KbC == id
    end

    def close
      close!
    end

    def needs_redraw?
      nil == @draw_image
    end

    def needs_cursor?
      false
    end
  end
end

begin
  Pixelflut::App.run
rescue Interrupt
  exit
end if __FILE__ == $PROGRAM_NAME
