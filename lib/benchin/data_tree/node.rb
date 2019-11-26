module Benchin
  class DataTree
    # @api private
    class Node
      attr_reader :name
      attr_reader :data
      attr_reader :nested

      attr_reader :config

      def initialize(name, config)
        @name = name
        @nested = {}
        @config = config

        @data = default_fields
      end

      def get_or_create_node_path(name_path)
        return [self] if name_path.empty?

        next_node_name = name_path.first

        [self] + (
          nested[next_node_name] ||= Node.new(next_node_name, config)
        ).get_or_create_node_path(name_path[1..-1])
      end

      def deep_sort_nested
        @nested =
          @nested
          .sort { |(_, node_a), (_, node_b)| @config.on_sort.call(node_a.data, node_b.data) }
          .to_h

        @nested.each_value(&:deep_sort_nested)

        self
      end

      def aggregate(context = nil)
        @nested.each_value do |node|
          node.aggregate(context)
          child_data = node.data

          @config.on_aggregate.call(context, @data, child_data)
        end

        self
      end

      def to_h
        @data.merge(
          nested: @nested.transform_values(&:to_h)
        )
      end

      def to_s
        NodeTextRenderer.new(self).call
      end

      private

      def default_fields
        config.default_fields
      end
    end
  end
end
