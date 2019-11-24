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

    def run
      connect
      send(@socket, @data)
      @socket.close
    end

    private

    def send(socket, data)
      curr = String.new(data)
      loop do
        written = socket.write(curr)
        curr =
          if (size = curr.bytesize - written) > 0
            curr.byteslice(written, size)
          else
            String.new(data)
          end
      end
    end

    def connect
      loop do
        (
          :wait_writable == @socket.connect_nonblock(@addr, exception: false)
        ) and break
      end
      loop{ @socket.wait_writable(10) and break }
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
