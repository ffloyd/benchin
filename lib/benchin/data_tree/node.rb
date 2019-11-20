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

        @data = config.default_fields
        @config = config
      end

      def push_event(name_path, event)
        @config.on_add.call(@data, event, @nested.empty?)

        head = name_path[0]
        return unless head

        (
          @nested[head] ||= self.class.new(head, config)
        ).push_event(name_path[1..-1], event)

        self
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
    end
  end
end
