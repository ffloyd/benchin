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
      keyword_init: true
    ) do
      def initialize(
        title_color: [],
        value_color: [],
        **
      )
        super
      end

      def default
        default_proc.call
      end
    end
  end
end
