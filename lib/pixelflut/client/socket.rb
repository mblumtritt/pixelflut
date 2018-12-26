# frozen_string_literal: true

require 'socket'

module Pixelflut
  class Client
    class Socket < ::Socket
      def initialize(address)
        super(address.ipv6? ? :INET6 : :INET, :STREAM)
        @addr = ::Socket.pack_sockaddr_in(address.ip_port, address.ip_address)
        configure
      end

      def write_with_timout(data, timeout)
        return true if write_nonblock(data, exception: false) == data.bytesize
        return false unless wait_writable(timeout)
        write_nonblock(data, exception: false) == data.bytesize
      end

      def readline_with_timeout(timeout)
        deadline = Time.now + timeout
        ret = ''
        loop do
          got = read_nonblock(16, exception: false)
          if got == :wait_readable
            remaining_time = deadline - Time.now
            return nil if remaining_time <= 0 || wait_readable(remaining_time).nil?
            next
          end
          idx = got.index("\n")
          next ret += got unless idx
          return ret + got[0, idx]
        end
      end

      def connect?
        :wait_writable != connect_nonblock(@addr, exception: false)
      end

      private

      def configure
        self.sync = true
        setsockopt(:TCP, :NODELAY, 1)
        setsockopt(:SOCKET, :KEEPALIVE, 0)
        self.do_not_reverse_lookup = true
      end
    end

    class NonblockSocket < Socket
      attr_reader :state

      def initialize(address, data)
        super(address)
        @state = :not_connected
        @data = data
        @size = data.bytesize
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
        @state = connect? ? :write : :wait_connect
      end

      def do_wait_for_connect
        @state = :not_connected unless wait_writable(0.1).nil?
      end

      def do_write
        written = write_nonblock(@data, exception: false)
        return written if Symbol === written
        @size -= written
        return @state = :write_finished if @size <= 0
        @data = @data.byteslice(written, @data.bytesize - written)
      end
    end
  end
end
