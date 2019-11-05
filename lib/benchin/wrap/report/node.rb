module Benchin
  module Wrap
    class Report
      # @api private
      class Node
        attr_reader :name
        attr_reader :calls
        attr_reader :total_seconds
        attr_reader :nested

        def initialize(name)
          @name = name

          @calls = 0
          @total_seconds = 0.0
          @nested = {}
        end

        def add_call(seconds)
          @nested_seconds = nil
          @calls += 1
          @total_seconds += seconds
        end

        def to_h
          {
            name: name,
            calls: calls,
            total_seconds: total_seconds,
            self_seconds: total_seconds - nested_seconds,
            child_seconds: nested_seconds,
            nested: nested.values.map(&:to_h)
          }
        end

        def nested_seconds
          child_nodes = nested.values

          @nested_seconds ||= 0.0 +
                              child_nodes.map(&:total_seconds).sum +
                              child_nodes.map(&:nested_seconds).sum
        end
      end
    end
  end
end
