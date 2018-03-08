# frozen_string_literal: true

require_relative 'base'

module Pixelflut
  module Canvas
    class Buffered < Base
      def clear!
        @lines = []
      end

      def each(&block)
        block ? @lines.each(&block) : to_enum(__method__)
      end

      def to_s
        @lines.join
      end

      private

      def out(str)
        @lines << str
      end
    end
  end
end
