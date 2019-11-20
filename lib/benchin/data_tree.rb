require_relative './data_tree/field_config'
require_relative './data_tree/config'
require_relative './data_tree/dsl'
require_relative './data_tree/node'

module Benchin
  # @api private
  class DataTree
    extend DSL

    def initialize(name = 'ROOT')
      @root = Node.new(name, config)
    end

    def add(name_path, event)
      @root.push_event(name_path, event)
    end

    def to_h
      @root
        .aggregate(@root.data)
        .deep_sort_nested
        .to_h
    end

    def to_s
      to_h.inspect
    end

    def config
      self.class.config
    end
  end
end
