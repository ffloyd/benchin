module Benchin
  class DataTree
    # @api private
    FieldConfig = Struct.new(
      :name,
      :title,
      :title_color,
      :value_color,
      :default_proc,
      :root_only,
      :child_only,
      :suffix,
      :float_truncate,
      keyword_init: true
    ) do
      def initialize(
        title_color: [],
        value_color: [],
        **rest
      )
        super(
          title_color: ColorDefinition.new(title_color),
          value_color: ColorDefinition.new(value_color),
          **rest
        )
      end

      def default
        default_proc.call
      end
    end
  end
end
