require_relative './data_tree/field_config'
require_relative './data_tree/config'
require_relative './data_tree/dsl'
require_relative './data_tree/node'
require_relative './data_tree/root_node'
require_relative './data_tree/node_text_renderer'

module Benchin
  # Defines generalized data structure for collecting and rendering tree-like reports.
  #
  # @abstract Use provided {DSL} in a child class to configure a specific DataTree.
  class DataTree
    extend DSL

    # Creates an empty tree with a single root node.
    #
    # @param name [String] name for the root node
    def initialize(name = 'ROOT')
      @root = RootNode.new(name, config)
    end

    # Adds an event to a provided path in a tree.
    #
    # If no such path presented in a tree - creates it.
    #
    # Event is applied to each node in `name_path` by using `on_add` callback
    # from configuration (see {DSL.on_add}).
    #
    # @param name_path [Array<String>] path in a tree (without root node)
    # @param event event object to process
    # @return [DataTree] self
    def add(name_path, event)
      node_path = @root.get_or_create_node_path(name_path)
      config.on_add.call(node_path, event)
      self
    end

    # Adds an event to a root node.
    #
    # @param event event object to process
    # @return [DataTree] self
    def add_to_root(event)
      config.on_add_to_root.call(@root.data, event)
      self
    end

    # Renders to Hash using provided configuration.
    #
    # @return [Hash] hash representation
    def to_h
      @root.to_h
    end

    # Renders to string with TTY colors.
    #
    # @return [String]
    def to_s
      @root.to_s
    end

    # Returns current configuration
    #
    # @return [Config]
    def config
      self.class.config
    end

    def postprocess
      @root.deep_sort_nested(&config.node_comparator)
      config.postprocessor.call(@root.dfs_postorder)
      self
    end
  end
end
