# frozen_string_literal: true

require 'socket'
require_relative 'server/connection'
require_relative 'server/configuration'

module Pixelflut
  class Server
    attr_reader :config

    def initialize(canvas, config = Configuration.default)
      @canvas, @config = canvas, config
      @socket, @connections = nil, {}
      @peers = Hash.new{ |h, k| h[k] = 0 }
      @ccfg = Connection::Configuration.new(
        keep_alive_time: config.keep_alive_time,
        read_buffer_size: config.read_buffer_size,
        command_limit: config.command_limit,
        canvas: canvas,
        size_result: "SIZE #{canvas.width} #{canvas.height}\n".freeze,
        on_end: ->(conn){ @peers[conn.peeraddr] -= 1 if @connections.delete(conn) }
      ).freeze
    end

    def connection_count
      @connections.size
    end

    def update
      return create_socket unless @socket
      incoming = @socket.accept_nonblock(exception: false)
      create_connection(incoming) unless Symbol === incoming
      @connections.keys.each(&:update)
    end

    def run
      Thread.new do
        loop{ update }
      end
    end

    private

    def create_connection(socket)
      peeraddr = socket.peeraddr(false)[-1]
      count = @peers[peeraddr] + 1
      return socket.close if count > @config.peer_limit
      @peers[peeraddr] = count
      con = Connection.new(socket, peeraddr, @ccfg)
      @connections[con] = con
    end

    def create_socket
      @socket = @config.host ? TCPServer.new(@config.host, @config.port) : TCPServer.new(@config.port)
      @socket.listen(255)
    end
  end
end
