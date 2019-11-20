module Benchin
  class Stack
    class Report
      # @api private
      class Tree < DataTree
        node_title_color %i[bright]

        field_space 14
        value_space 7

        field :samples,
              default_proc: -> { 0 }

        field :global_percentage,
              default_proc: -> { 100.0 }

        field :local_percentage,
              default_proc: -> { 100.0 }

        on_add do |current_data, event, _is_leaf|
          current_data[:samples] += event[:samples]
        end

        on_aggregate do |root_data, parent_data, child_data|
          child_data[:global_percentage] = 100.0 * child_data[:samples] / root_data[:samples]
          child_data[:local_percentage] = 100.0 * child_data[:samples] / parent_data[:samples]
        end

        on_sort do |data_a, data_b|
          data_b[:samples] <=> data_a[:samples]
        end
      end
    end
  end
end
