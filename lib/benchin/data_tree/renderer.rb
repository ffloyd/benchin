module Benchin
  class DataTree
    # @abstract
    # @api private
    class Renderer
      def initialize(node, config)
        @node = node
        @config = config
      end

      def call
        raise NotImplementedError
      end
    end
  end
end
