# frozen_string_literal: true

require_relative 'base'

module Pixelflut
  module Canvas
    class Streamed < Base
      def initialize(stream = $stdout)
        super()
        @stream = stream
      end

      private

      def out(str)
        @stream.print(str)
      end
    end
  end
end
