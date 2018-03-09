# frozen_string_literal: true

require 'socket'

module Pixelflut
  class Client
    class Socket < ::Socket
      attr_reader :state

      def initialize(address, data)
        super(address.ipv6? ? :INET6 : :INET, :STREAM)
        configure
        @addr = ::Socket.pack_sockaddr_in(address.ip_port, address.ip_address)
        @data = data
        @size = data.bytesize
        @state = :not_connected
      end

      def call
        case @state
        when :not_connected
          do_connect
        when :wait_connect
          do_wait_for_connect
        when :write
          do_write
        else
          close
          @state = :closed
        end
      end

      private

      def do_connect
        @state = :wait_writable === connect_nonblock(@addr, exception: false) ? :wait_connect : :write
      end

      def do_wait_for_connect
        @state = :write unless wait_writable(0.1).nil?
      end

      def do_write
        written = write_nonblock(@data, exception: false)
        return if Symbol === written
        @size -= written
        return @state = :write_finished if @size <= 0
        @data = @data.byteslice(written, @data.bytesize - written)
      end

      def configure
        self.sync = true
        setsockopt(:TCP, :NODELAY, 1)
        setsockopt(:SOCKET, :KEEPALIVE, 0)
        self.do_not_reverse_lookup = true
      end
    end
  end
end
