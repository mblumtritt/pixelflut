# frozen_string_literal: true

require 'socket'

module Pixelflut
  class Server
    class Connection
      Configuration = Struct.new(
        :keep_alive_time,
        :read_buffer_size,
        :command_limit,
        :canvas,
        :size_result,
        :on_end,
        keyword_init: true
      )

      attr_reader :peeraddr

      def initialize(socket, peeraddr, config)
        @socket, @peeraddr, @config = socket, peeraddr, config
        @last_tm, @buffer = Time.now.to_f, ''
      end

      def close(_reason)
        socket, @socket = @socket, nil
        return unless socket
        socket.close
        @config.on_end.call(self)
        false
      end

      def update
        index = @buffer.index("\n")
        return process_loop(index) if index
        read_size = @config.read_buffer_size - @buffer.size
        return close(:buffer_exceeded) if read_size <= 0
        str = @socket.recv_nonblock(read_size, exception: false)
        now = Time.now.to_f
        return (now - @last_tm > @config.keep_alive_time ? close(:timeout) : nil) if Symbol === str
        return close(:closed_by_peer) if 0 == str.size
        @buffer += str
        @last_tm = now
      rescue Errno::ECONNRESET
        close(:closed_by_peer)
      end

      private

      def next_command(index)
        @buffer = @buffer[index, @buffer.size - index]
        @last_tm = Time.now.to_f
        true
      end

      def command_size(index)
        @socket.sendmsg_nonblock(@config.size_result)
        next_command(index)
      end

      def command_px(command, index)
        _, x, y, color = command.split(' ', 4)
        return close(:color_expected) unless color
        @config.canvas[x.to_i, y.to_i] = color
        next_command(index)
      end

      def command_rc(command, index)
        _, x1, y1, x2, y2, color = command.split(' ', 6)
        return close(:color_expected) unless color
        @config.canvas.draw_rect(x1.to_i, y1.to_i, x2.to_i, y2.to_i, color)
        next_command(index)
      end

      def process_loop(index)
        command_count = @config.command_limit
        while process_buffer(index)
          index = @buffer.index("\n") or return
          command_count -= 1
          break if command_count <= 0
        end
      end

      def process_buffer(index)
        return close(:max_command_size_exceeded) if index > 31 # 'RC 9999 9999 9999 9999 RRGGBBAA'.size
        command = @buffer[0, index]
        index += 1
        return command_px(command, index) if command.start_with?('PX ')
        return command_rc(command, index) if command.start_with?('RC ')
        return close(:quit) if command == 'QUIT'
        return command_size(index) if command == 'SIZE'
        close(:bad_command)
      end
    end

    private_constant(:Connection)
  end
end
