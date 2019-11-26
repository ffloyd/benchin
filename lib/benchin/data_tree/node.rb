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

      def sort_nested
        @nested =
          @nested
          .sort { |(_, node_a), (_, node_b)| yield(node_a.data, node_b.data) }
          .to_h

        self
      end

      def deep_sort_nested(&comparator)
        sort_nested(&comparator)

        nested.each_value do |nested_node|
          nested_node.deep_sort_nested(&comparator)
        end

        self
      end

      def dfs_postorder
        nested.values.map(&:dfs_postorder).flatten + [self]
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
