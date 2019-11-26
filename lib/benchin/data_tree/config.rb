module Benchin
  class DataTree
    # @api private
    Config = Struct.new(
      :node_title_color,
      :field_space,
      :value_space,
      :fields,
      :on_add,
      :on_root_add,
      :on_aggregate,
      :node_comparator,
      keyword_init: true
    ) do
      NEUTRAL_PROC = proc {}
      STANDARD_NODE_COMPARATOR = ->(left, right) { left <=> right }

      # :reek:LongParameterList:
      def initialize(
        node_title_color: [],
        field_space: 14,
        value_space: 7,
        fields: {},
        on_add: NEUTRAL_PROC,
        on_root_add: NEUTRAL_PROC,
        on_aggregate: NEUTRAL_PROC,
        node_comparator: STANDARD_NODE_COMPARATOR,
        **
      )
        super
      end

      def initialize_dup(orig)
        super
        self.node_title_color = orig.node_title_color.dup
        self.fields = orig.fields.transform_values(&:dup)
      end

      def default_fields
        fields
          .reject { |_, field_cfg| field_cfg.root_only }
          .transform_values(&:default)
      end

      def default_root_fields
        fields
          .reject { |_, field_cfg| field_cfg.child_only }
          .transform_values(&:default)
      end
    end
  end
end
