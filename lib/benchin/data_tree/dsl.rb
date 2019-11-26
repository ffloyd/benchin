module Benchin
  class DataTree
    # DSL for configuring {DataTree}s.
    #
    # Any color related field must contain array (can be empty) of colors for
    # [Rainbow gem](https://github.com/sickill/rainbow).
    module DSL
      # @return [Config] current config
      attr_reader :config

      def self.extended(mod)
        mod.instance_variable_set(:@config, Config.new)

        mod.class_exec do
          def self.inherited(child_class)
            child_class.instance_variable_set(:@config, instance_variable_get(:@config).dup)
          end
        end
      end

      # Color for a node title.
      #
      # @param color_list [Array<Symbol>]
      def node_title_color(color_list)
        @config.node_title_color = color_list
      end

      # Space reserved for field titles when rendering to string.
      #
      # @param characters [Integer]
      def field_space(characters)
        @config.field_space = characters
      end

      # Space reserved for field values when rendering to string.
      #
      # @param characters [Integer]
      def value_space(characters)
        @config.value_space = characters
      end

      # Defines a new field.
      #
      # @param name [Symbol] name of a field
      # @option field_definition [String] title Title of field when rendering to string.
      #   Required field.
      # @option field_definition [Proc] default_proc Proc which returns default value for a field.
      #   Default value generates `nil`.
      # @option field_definition [Boolean] root_only Is this field should exist only in a root node?
      def field(name, **field_definition)
        @config.fields[name] = FieldConfig.new(name: name, **field_definition)
      end

      # Callback to define logic when a new event added using {DataTree#add}.
      #
      # Callback executed for each node in a path and can modify node data.
      #
      # @yield [node_data, event, is_leaf] callback to execute.
      # @yieldparam [Hash] node_data Data of a current node. Can be modified.
      # @yieldparam event Event to process.
      # @yieldparam [Boolean] is_leaf Is current node a leaf or not?
      def on_add(&block)
        @config.on_add = block
      end

      # Callback to define logic when a new root event added using {DataTree#add_to_root}.
      #
      # Callback executed for root node only and can modify node data.
      #
      # @yield [root_node_data, event] callback to execute.
      # @yieldparam [Hash] root_node_data Data of a root node. Can be modified.
      # @yieldparam event Event to process.
      def on_add_to_root(&block)
        @config.on_add_to_root = block
      end

      # Callback to define aggregation logic.
      #
      # Aggregation performs before rendering to Hash or String.
      #
      # Callback executed for each edge in a tree.
      # Order of edges is a [DFT post-order](https://www.geeksforgeeks.org/tree-traversals-inorder-preorder-and-postorder/).
      #
      # @yield [root_node_data, parent_node_data, child_node_data] callback to execute.
      # @yieldparam [Hash] root_node_data Data of a root node. Can be modified.
      # @yieldparam [Hash] parent_node_data Data of a parent node. Can be modified.
      # @yieldparam [Hash] child_node_data Data of a child node. Can be modified.
      def postprocessor(&block)
        @config.postprocessor = block
      end

      # Callback to sorting child nodes.
      #
      # @yield [node_a_data, node_b_data] comparison operation on node data. It should work like `<=>`.
      # @yieldparam [Hash] node_a_data
      # @yieldparam [Hash] node_b_data
      # @yieldreturn [Integer] -1, 0 or 1
      def node_comparator(&block)
        @config.node_comparator = block
      end
    end
  end
end
