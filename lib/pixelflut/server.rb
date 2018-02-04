# frozen_string_literal: true

require 'socket'

module Pixelflut
  class Server
    Configuration = Struct.new(
      :host,
      :port,
      :keep_alive_time,
      :read_buffer_size
    ) do
      def self.default
        new(nil, 1234, 1, 1024)
      end
    end

    attr_reader :config

    def initialize(canvas, config = Configuration.default)
      @canvas, @config = canvas, config
      @socket, @connections = nil, {}
      @on_end = ->(conn){ @connections.delete(conn) }
      @size = "SIZE #{canvas.width} #{canvas.height}\n".freeze
    end

    def connection_count
      @connections.size
    end

    def update
      return create_socket unless @socket
      now = Time.now.to_f
      incoming = @socket.accept_nonblock(exception: false)
      create_connection(incoming, now) unless Symbol === incoming
      @connections.keys.each{ |con| con.update(now) }
    end

    def run
      Thread.new do
        loop{ update }
      end
    end

    private

    def create_connection(incoming, now)
      con = Connection.new(incoming, now, @config, @canvas, @size, @on_end)
      @connections[con] = con
    end

    def create_socket
      @socket = @config.host ? TCPServer.new(@config.host, @config.port) : TCPServer.new(@config.port)
      @socket.listen(255)
    end

    class Connection
      def initialize(socket, now, config, canvas, size, on_end)
        @socket, @last_tm, @config, @canvas, @size, @on_end = socket, now, config, canvas, size, on_end
        # @socket.setsockopt(Socket::IPPROTO_TCP, Socket::TCP_NODELAY, 1)
        @buffer = ''
      end

      def close(_reason)
        socket, @socket = @socket, nil
        return unless socket
        socket.close
        @on_end.call(self)
      end

      def update(now)
        index = @buffer.index("\n")
        return process_buffer(index, now) if index
        read_size = @config.read_buffer_size - @buffer.size
        return close(:buffer_exceeded) if read_size <= 0
        str = @socket.recv_nonblock(read_size, exception: false)
        return (now - @last_tm > @config.keep_alive_time ? close(:timeout) : nil) if Symbol === str
        return close(:closed_by_peer) if 0 == str.size
        @buffer += str
        @last_tm = now
      end

      private

      def next_command(index, now)
        @buffer = @buffer[index, @buffer.size - index]
        @last_tm = now
      end

      def command_size(index, now)
        @socket.sendmsg_nonblock(@size)
        next_command(index, now)
      end

      def command_px(command, index, now)
        _, x, y, color = command.split(' ', 4)
        return close(:color_expected) unless color
        @canvas[x.to_i, y.to_i] = color
        next_command(index, now)
      end

      def command_rc(command, index, now)
        _, x1, y1, x2, y2, color = command.split(' ', 6)
        return close(:color_expected) unless color
        @canvas.draw_rect(x1.to_i, y1.to_i, x2.to_i, y2.to_i, color)
        next_command(index, now)
      end

      def process_buffer(index, now)
        return close(:max_command_size_exceeded) if index > 31 # 'RC 9999 9999 9999 9999 RRGGBBAA'.size
        command = @buffer[0, index]
        index += 1
        return command_size(index, now) if command == 'SIZE'
        return close(:quit) if command == 'QUIT'
        return command_px(command, index, now) if command.start_with?('PX ')
        return command_rc(command, index, now) if command.start_with?('RC ')
        close(:bad_command)
      end
    end
  end
end
