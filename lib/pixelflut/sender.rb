require 'socket'

module Pixelflut
  class Sender
    def self.address(host, port)
      Addrinfo.tcp(host, port)
    end

    attr_reader :state

    def initialize(address, data)
      @data = data.freeze
      @addr = Socket.pack_sockaddr_in(address.ip_port, address.ip_address)
      @socket = configure(Socket.new(address.ipv6? ? :INET6 : :INET, :STREAM))
      @state = :not_connected
    end

    def inspect
      "<#{self.class}:#{__id__} state:#{@state}>"
    end

    def call
      case @state
      when :not_connected
        @state = :wait_connect if connect
      when :wait_connect
        @state = :write_prepare if connected
      when :write_prepare
        @state = :write if prepared
      when :write
        @state = :write_prepare unless written
      else
        close
        @state = :closed
      end
      @state
    end
    alias update call

    protected

    def connect
      :wait_writable == @socket.connect_nonblock(@addr, exception: false)
    end

    def connected
      nil != @socket.wait_writable(1.0)
    end

    def prepared
      @curr = String.new(@data)
      @size = @curr.bytesize
    end

    def written
      ret = @socket.write_nonblock(@curr, exception: false)
      return false if Symbol === ret
      return true if (@size -= ret) <= 0
      @curr = @curr.byteslice(ret, @curr.bytesize - ret)
    end

    private

    def configure(socket)
      socket.sync = true
      socket.setsockopt(:TCP, :NODELAY, 1)
      socket.setsockopt(:SOCKET, :KEEPALIVE, 0)
      socket.do_not_reverse_lookup = true
      socket
    end
  end
end
