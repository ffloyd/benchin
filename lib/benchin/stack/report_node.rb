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

      def to_h
        {
          samples: @samples,
          nested: @nested.transform_values(&:to_h)
        }
      end
    end
  end
end
