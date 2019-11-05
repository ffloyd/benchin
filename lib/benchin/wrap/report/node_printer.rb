require 'rainbow'

module Benchin
  module Wrap
    class Report
      # @api private
      class NodePrinter
        FIELD_SPACE = 14
        VALUE_SPACE = 7
        PRECISION = 3

        # Human readable report generator.
        #
        # Uses TTY colors.
        #
        # @param node [Node] node to print
        # @param level [Integer] defines current level of nesting
        def initialize(node, level: 0)
          @node = node
          @level = level
        end

        # @return [String] rendered report
        def to_s
          [
            body,
            @node.nested.values.map do |child_node|
              self.class.new(child_node, level: @level + 1).to_s
            end
          ].flatten.join("\n")
        end

        private

        def body
          nav = '|   '
          prefix = nav * @level

          [
            title,
            nav + calls,
            nav + time_all,
            nav + time_self,
            nav + time_childs
          ].map { |line| prefix + line }.join("\n")
        end

        def title
          "#{Rainbow(@node.name).bright} ->"
        end

        def calls
          'calls:'.ljust(FIELD_SPACE) +
            Rainbow(
              @node.calls
                .to_s
                .rjust(VALUE_SPACE)
            ).blue
        end

        def time_all
          'time(all):'.ljust(FIELD_SPACE) +
            Rainbow(
              @node.total_seconds
                .truncate(PRECISION)
                .to_s
                .rjust(VALUE_SPACE)
            ).green
        end

        def time_self
          'time(self):'.ljust(FIELD_SPACE) +
            Rainbow(
              @node.self_seconds
                .truncate(PRECISION)
                .to_s
                .rjust(VALUE_SPACE)
            ).green.bright
        end

        def time_childs
          'time(childs):'.ljust(FIELD_SPACE) +
            Rainbow(
              @node.child_seconds
                .truncate(PRECISION)
                .to_s
                .rjust(VALUE_SPACE)
            ).green
        end
      end
    end
  end
end
