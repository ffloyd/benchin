module Benchin
  class DataTree
    # @api private
    # :reek:Attribute:
    FieldConfig = Struct.new(
      :name,
      :title,
      :type,
      :precision,
      :value_suffix,
      :default_proc,
      keyword_init: true
    ) do
      def initialize(*)
        super
      end

      def default
        default_proc.call
      end
    end
  end
end
