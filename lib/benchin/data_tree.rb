require_relative './data_tree/field_config'
require_relative './data_tree/config'
require_relative './data_tree/dsl'
require_relative './data_tree/node'

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
      @root = Node.new(name, config)
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
      @root.push_event(name_path, event)
      self
    end

    # Renders to Hash using provided configuration.
    #
    # @return [Hash] hash representation
    def to_h
      @root
        .aggregate(@root.data)
        .deep_sort_nested
        .to_h
    end

    # Renders to string with TTY colors.
    #
    # @return [String]
    def to_s
      to_h.inspect
    end

    # Returns current configuration
    #
    # @return [Config]
    def config
      self.class.config
    end
  end
end
