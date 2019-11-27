require 'socket'

module Pixelflut
  class Sender
    def self.address(host, port)
      Addrinfo.tcp(host, port)
    end

    def initialize(address, data)
      @data = data.freeze
      @addr = Socket.pack_sockaddr_in(address.ip_port, address.ip_address)
      @socket = configure(Socket.new(address.ipv6? ? :INET6 : :INET, :STREAM))
    end

    def size
      @data.bytesize
    end

    def run(&block)
      @socket.connect(@addr)
      send(@socket, @data, @data.bytesize, &block)
      @socket.close
    end

    private

    def send(socket, data, bytesize)
      index, curr, size = 0, data, bytesize
      loop do
        written = socket.write(curr)
        if (size -= written) > 0
          yield(self) if block_given?
          curr = data.byteslice(index += written, size)
        else
          index, curr, size = 0, data, bytesize
        end
      end
    end

    def configure(socket)
      socket.sync = true
      socket.setsockopt(:TCP, :NODELAY, 1)
      socket.setsockopt(:SOCKET, :KEEPALIVE, 0)
      socket.do_not_reverse_lookup = true
      socket
    end
  end
end
