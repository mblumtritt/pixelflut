# frozen_string_literal: true

module Pixelflut
  module Sender
    def self.as_address(host, port)
      require('socket') unless defined?(Addrinfo)
      info = Addrinfo.tcp(host, port)
      Address.new(
        Socket.pack_sockaddr_in(info.ip_port, info.ip_address),
        info.ipv6? ? :INET6 : :INET
      )
    end

    def self.send(address, data)
      socket = create_socket(address)
      yield(data.bytesize) if block_given?
      socket.write(data) while true
    end

    def self.create_socket(address)
      socket = Socket.new(address.type, :STREAM)
      socket.connect(address.sockaddr_in)
      socket.setsockopt(:TCP, :NODELAY, 1)
      socket.setsockopt(:SOCKET, :KEEPALIVE, 0)
      socket.sync = socket.do_not_reverse_lookup = true
      socket
    end

    Address = Struct.new(:sockaddr_in, :type)
  end
end
