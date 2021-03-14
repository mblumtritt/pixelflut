require 'socket'

module Pixelflut
  module Sender
    def self.address(host, port)
      Addrinfo.tcp(host, port)
    end

    def self.send(address, data)
      socket = create_socket(address)
      yield(socket) if block_given?
      loop { socket.write(data) }
    end

    def self.create_socket(address)
      Socket
        .new(address.ipv6? ? :INET6 : :INET, :STREAM)
        .tap do |socket|
          socket.sync = false
          socket.setsockopt(:TCP, :NODELAY, 0)
          socket.setsockopt(:SOCKET, :KEEPALIVE, 0)
          socket.do_not_reverse_lookup = true
          socket.connect(
            Socket.pack_sockaddr_in(address.ip_port, address.ip_address)
          )
        end
    end
  end
end
