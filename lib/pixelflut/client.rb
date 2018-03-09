# frozen_string_literal: true

require_relative 'client/socket'

module Pixelflut
  class Client
    def initialize(host, port, data, socket_count)
      @sockets = create_sockets(Addrinfo.tcp(host, port), sliced(data, socket_count))
    end

    def run
      loop{ break if call }
    end

    def call
      @sockets.size == @sockets.count do |socket|
        socket.call
        socket.state == :closed
      end
    end

    private

    def sliced(data, count)
      data = data.split("\n") if data.is_a?(String)
      data = data.each_slice(data.size / count).to_a
      data[-2] += data.pop unless (data.size % count).zero?
      data.map!(&:join)
    end

    def create_sockets(address, slices)
      slices.map{ |data| Socket.new(address, data) }
    end
  end
end
