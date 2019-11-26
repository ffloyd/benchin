module Benchin
  class DataTree
    class Node
      # @api private
      class Root < Node
        private

        def default_fields
          config.default_root_fields
        end
      end
    end
  end
end
