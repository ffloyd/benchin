module Benchin
  class DataTree
    # @api private
    class RootNode < Node
      def push_root_event(event)
        config.on_root_add.call(data, event)
      end

      private

      def default_fields
        config.default_root_fields
      end
    end
  end
end
