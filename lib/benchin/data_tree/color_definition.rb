require 'rainbow'

module Benchin
  class DataTree
    # @api private
    class ColorDefinition
      attr_reader :color_list

      def initialize(color_list)
        @color_list = color_list
      end

      def apply(text)
        color_list.reduce(Rainbow(text)) do |rb_text, color|
          rb_text.public_send(color)
        end
      end
    end
  end
end
