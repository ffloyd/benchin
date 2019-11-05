require_relative './report/node'

module Benchin
  module Wrap
    # Represents tree-like time measurement data produced by {Wrap}.
    #
    # See {#to_a} method for more concrete example.
    class Report
      def initialize
        @data_tree = Node.new('ROOT')
      end

      # Adds seconds to a {path} in a tree and increases calls count by 1.
      #
      # @param path [Array<String>] path in a report tree.
      # @param seconds [Float] amount of total seconds spent in this call (including child calls).
      #
      # @return [Report] self
      def add_time(path, seconds)
        target_node = path.reduce(@data_tree) do |node, name|
          node.nested[name] ||= Node.new(name)
        end

        target_node.add_call(seconds)

        self
      end

      # Transforms report to a basic ruby types: arrays and hashes.
      #
      # @example
      #   report = Report.new
      #   report
      #     .add_time(%w[TOP NESTED], 10.0)
      #     .add_time(%w[TOP], 10.0)
      #     .add_time(%w[TOP], 5.0)
      #     .add_time(%w[NESTED], 7.0)
      #     .to_a
      #   # will produce following structure
      #   [
      #     {
      #       name: 'TOP',
      #       total_seconds: 15.0,
      #       self_seconds: 5.0,
      #       child_seconds: 10.0,
      #       calls: 2,
      #       nested: [
      #         {
      #           name: 'NESTED',
      #           total_seconds: 10.0,
      #           self_seconds: 10.0,
      #           child_seconds: 0.0,
      #           calls: 1,
      #           nested: []
      #         }
      #       ]
      #     },
      #     {
      #       name: 'NESTED',
      #       total_seconds: 7.0,
      #       self_seconds: 7.0,
      #       child_seconds: 0.0,
      #       calls: 1,
      #       nested: []
      #     }
      #   ]
      #
      # @return [Array] report represented using {Array}s and {Hash}es. It's safe to modify it.
      def to_a
        @data_tree.to_h[:nested]
      end
    end
  end
end
