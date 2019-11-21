module Benchin
  class DataTree
    # @api private
    FieldConfig = Struct.new(
      :name,
      :title,
      :default_proc,
      :root_only,
      keyword_init: true
    ) do
      def initialize(**)
        super
      end

      def default
        default_proc.call
      end
    end
  end
end
