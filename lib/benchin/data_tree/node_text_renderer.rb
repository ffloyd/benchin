require 'rainbow'

module Benchin
  class DataTree
    # @api private
    class NodeTextRenderer
      # @return [Node]
      attr_reader :node

      def initialize(node, level: 0)
        @node = node
        @level = level
      end

      def call
        [
          body,
          nested
        ].flatten.join("\n")
      end

      private

      def body
        [
          title,
          data
        ].flatten.join("\n")
      end

      def title
        [
          prefix(@level),
          colorize(node.name, node.config.node_title_color),
          ' ->'
        ].join
      end

      def data
        field_names = node.config.fields.keys & node.data.keys

        field_names
          .map { |field_name| field(field_name) }
          .join("\n")
      end

      def field(name)
        field_cfg = node.config.fields[name]

        [
          prefix(@level + 1),
          render_title(field_cfg),
          render_value(node.data[name], field_cfg)
        ].join
      end

      def render_title(field_config)
        colorize(
          field_config.title.ljust(node.config.field_space),
          field_config.title_color
        )
      end

      def render_value(value, field_config)
        colorize(
          prepare_value(value, field_config).to_s.rjust(node.config.value_space),
          field_config.value_color
        )
      end

      def prepare_value(value, field_config)
        float_truncate = field_config.float_truncate
        suffix = field_config.suffix

        value = value.truncate(float_truncate) if float_truncate
        value = value.to_s + suffix if suffix

        value
      end

      def nested
        node.nested.values.map do |nested_node|
          self.class.new(nested_node, level: @level + 1).call
        end
      end

      # :reek:UtilityFunction
      def prefix(indent)
        '|   ' * indent
      end

      # :reek:Utilityfunction
      def colorize(text, color_list)
        color_list.reduce(Rainbow(text)) do |rb_text, color|
          rb_text.public_send(color)
        end
      end
    end
  end
end
