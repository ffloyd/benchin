module Benchin
  class DataTree
    # @api private
    Config::Field = Struct.new(
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
          title_color: Config::Color.new(title_color),
          value_color: Config::Color.new(value_color),
          **rest
        )
      end

      def default
        default_proc.call
      end
    end
  end
end
