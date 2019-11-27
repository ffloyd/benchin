module Benchin
  class DataTree
    class Renderer
      class Term
        # @api private
        class Field
          def initialize(value, config, level:)
            @value = value
            @config = config
            @level = level
          end

          def call
            [
              prefix,
              formatted_title,
              formatted_value
            ].join
          end

          private

          def prefix
            '|    ' * @level
          end

          def formatted_title
            @config.title_color.apply(
              @config.title.ljust(@config.field_space)
            )
          end

          def formatted_value
            @config.title_color.apply(
              prepared_value.ljust(@config.value_space)
            )
          end

          def prepared_value
            value = @value

            float_truncate = @config.float_truncate

            value = value.truncate(float_truncate) if float_truncate
            value = value.to_s + (@config.suffix || '')

            value
          end
        end
      end
    end
  end
end
