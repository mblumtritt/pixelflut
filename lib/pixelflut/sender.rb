require 'socket'

module Pixelflut
  module Sender
    module_function

    def address(host, port)
      Addrinfo.tcp(host, port)
    end

    def send(address, data)
      socket = create_socket(address)
      loop{ socket.write(data) }
    end

    def create_socket(address)
      socket = Socket.new(address.ipv6? ? :INET6 : :INET, :STREAM)
      # socket.sync = true
      # socket.setsockopt(:TCP, :NODELAY, 1)
      socket.setsockopt(:SOCKET, :KEEPALIVE, 0)
      socket.do_not_reverse_lookup = true
      socket.connect(
        Socket.pack_sockaddr_in(address.ip_port, address.ip_address)
      )
      socket
    end
  end
end
