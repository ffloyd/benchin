module Benchin
  class Wrap
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
          @child_seconds = nil
          @calls += 1
          @total_seconds += seconds
        end

        def to_h
          {
            name: name,
            calls: calls,
            total_seconds: total_seconds,
            self_seconds: self_seconds,
            child_seconds: child_seconds,
            nested: nested.values.map(&:to_h)
          }
        end

        def self_seconds
          total_seconds - child_seconds
        end

        def child_seconds
          child_nodes = nested.values

          @child_seconds ||= child_nodes.map(&:total_seconds).sum.to_f
        end

        # Virtual Node is a node without ability to track time in.
        #
        # It is designed to be used as container for nested nodes.
        #
        # @api private
        class Virtual < Node
          def total_seconds
            child_seconds
          end

          def self_seconds
            0.0
          end

          def add_time
            raise 'Cannot add time to a virtual node'
          end

          def to_h
            {
              name: name,
              total_seconds: total_seconds,
              nested: nested.values.map(&:to_h)
            }
          end
        end
      end
    end
  end
end
