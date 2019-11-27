module Benchin
  class DataTree
    class Renderer
      # Renders to text with terminal coloring.
      class Term < Renderer
        def initialize(*args, level: 0, **rest)
          @level = level
          super(*args, **rest)
        end

        def call
          [
            title,
            fields,
            nested
          ].flatten.join("\n")
        end

        private

        def title
          title_text = @config.node_title_color.apply(@node.name)

          prefix + title_text + ' ->'
        end

        def prefix
          '|    ' * @level
        end

        def fields
          data = node.data
          fields_cfg = @config.fields

          field_names = fields_cfg.keys & data.keys

          field_names.map do |field_name|
            self.class::Field
              .new(data[field_name], fields_cfg[field_name], level: @level + 1)
              .call
          end.join("\n")
        end

        def nested
          @node.nested.values.map do |nested_node|
            self.class.new(nested_node, @config, level: @level + 1).call
          end
        end
      end
    end
  end
end
