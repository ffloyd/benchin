module Benchin
  class DataTree
    # @api private
    module DSL
      attr_reader :config

      def self.extended(mod)
        mod.instance_variable_set(:@config, Config.new)

        mod.class_exec do
          def self.inherited(child_class)
            child_class.instance_variable_set(:@config, instance_variable_get(:@config).dup)
          end
        end
      end

      def node_title_color(color_list)
        @config.node_title_color = color_list
      end

      def field_space(characters)
        @config.field_space = characters
      end

      def value_space(characters)
        @config.value_space = characters
      end

      def field(name, **field_definition)
        @config.fields[name] = FieldConfig.new(name: name, **field_definition)
      end

      def on_add(&block)
        @config.on_add = block
      end

      def on_aggregate(&block)
        @config.on_aggregate = block
      end

      def on_sort(&block)
        @config.on_sort = block
      end
    end
  end
end
