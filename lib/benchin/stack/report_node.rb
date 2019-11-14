module Benchin
  class Stack
    # @api private
    class ReportNode
      def initialize(name)
        @name = name

        @samples = 0
        @nested = {}
      end

      def add_samples(samples, path)
        @samples += samples

        head = path[0]
        tail = path[1..-1]

        return unless head

        (
          @nested[head] ||= self.class.new(head)
        ).add_samples(samples, tail)
      end

      def to_h(total_samples = nil, parent_samples = nil)
        parent_samples ||= @samples
        total_samples ||= parent_samples

        {
          samples: @samples,
          local_percentage: calc_percentage(parent_samples),
          global_percentage: calc_percentage(total_samples),
          nested: @nested.transform_values { |nested_node| nested_node.to_h(total_samples, @samples) }
        }
      end

      private

      def calc_percentage(total)
        return 100.0 if total.zero?

        ((@samples.to_f * 100) / total).truncate(3)
      end
    end
  end
end
