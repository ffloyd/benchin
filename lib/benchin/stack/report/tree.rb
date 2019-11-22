module Benchin
  class Stack
    class Report
      # @api private
      class Tree < DataTree
        node_title_color %i[bright]

        field_space 20
        value_space 7

        field :samples,
              title: 'Samples:',
              default_proc: -> { 0 },
              title_color: %i[blue],
              value_color: %i[green bright]

        field :global_percentage,
              title: '% of total samples:',
              default_proc: -> { 100.0 },
              suffix: '%',
              float_truncate: 2,
              title_color: %i[blue],
              value_color: %i[green]

        field :local_percentage,
              title: '% of parent samples:',
              default_proc: -> { 100.0 },
              suffix: '%',
              float_truncate: 2,
              title_color: %i[blue],
              value_color: %i[green]

        field :missed_samples,
              title: 'Missed Samples:',
              default_proc: -> { 0 },
              title_color: %i[blue],
              value_color: %i[green],
              root_only: true

        on_add do |current_data, event, _is_leaf|
          current_data[:samples] += event[:samples]
        end

        on_root_add do |root_data, event|
          root_data[:missed_samples] += event[:missed_samples]
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
