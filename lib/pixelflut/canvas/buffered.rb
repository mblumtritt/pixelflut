# frozen_string_literal: true

require_relative 'base'

module Pixelflut
  module Canvas
    class Buffered < Base
      def clear!
        @lines = []
      end

      def each(&block)
        return to_enum(__method__) unless block
        @lines.each(&block)
        yield "QUIT\n"
      end

      def to_s
        @lines.join + "QUIT\n"
      end

      private

      def out(str)
        @lines << str
      end
    end
  end
end
