# frozen_string_literal: true

require 'socket'

module Pixelflut
  module Sender
    def self.as_address(host, port)
      @address_class ||= Data.define(:sockaddr_in, :type)
      info = Addrinfo.tcp(host, port)
      @address_class.new(
        Socket.pack_sockaddr_in(info.ip_port, info.ip_address),
        info.ipv6? ? :INET6 : :INET
      )
    end

    def self.send(address, data)
      socket = create_socket(address)
      yield(data.bytesize) if block_given?
      loop { socket.write(data) }
    end

    def self.create_socket(address)
      socket = Socket.new(address.type, :STREAM)
      socket.setsockopt(:TCP, :NODELAY, 1)
      socket.setsockopt(:SOCKET, :KEEPALIVE, 0)
      socket.sync = socket.do_not_reverse_lookup = true
      socket.connect(address.sockaddr_in)
      socket
    end
  end
end
