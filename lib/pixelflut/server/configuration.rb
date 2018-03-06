# frozen_string_literal: true

module Pixelflut
  class Server
    Configuration = Struct.new(
      :host,
      :port,
      :keep_alive_time,
      :read_buffer_size,
      :command_limit,
      :peer_limit
    ) do
      def self.default
        new(nil, 1234, 1, 1024, 10, 8)
      end

      def to_s
        "bind: #{host}:#{port}"\
          ", keep-alive-time: #{keep_alive_time}"\
          ", read-buffer-size: #{read_buffer_size}"\
          ", command-limit: #{command_limit}"\
          ", peer-limit: #{peer_limit}"
      end
    end
  end
end
