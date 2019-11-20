module Benchin
  class DataTree
    # @api private
    # :reek:Attribute:
    # :reek:TooManyInstanceVariables
    class Config
      NEUTRAL_PROC = proc {}

      attr_accessor :node_title_color

      attr_accessor :field_space
      attr_accessor :value_space

      attr_reader :fields

      attr_accessor :on_add
      attr_accessor :on_aggregate
      attr_accessor :on_sort

      # :reek:TooManyStatements
      def initialize
        @node_title_color = []

        @field_space = 14
        @value_space = 7

        @fields = {}

        @on_add = NEUTRAL_PROC
        @on_aggregate = NEUTRAL_PROC
        @on_sort = NEUTRAL_PROC
      end

      def initialize_dup(orig)
        @fields = orig.fields.transform_values(&:dup)
        super
      end

      def default_fields
        @fields.transform_values(&:default)
      end
    end
  end
end
