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
              value_color: %i[green],
              child_only: true

        field :local_percentage,
              title: '% of parent samples:',
              default_proc: -> { 100.0 },
              suffix: '%',
              float_truncate: 2,
              title_color: %i[blue],
              value_color: %i[green],
              child_only: true

        field :missed_samples,
              title: 'Missed Samples:',
              default_proc: -> { 0 },
              title_color: %i[blue],
              value_color: %i[green],
              root_only: true

        on_add do |node_path, event|
          node_path.each do |node|
            node.data[:samples] += event[:samples]
          end
        end

        on_root_add do |root_data, event|
          root_data[:missed_samples] += event[:missed_samples]
        end

        postprocessor do |dfs_postorder|
          root_samples = dfs_postorder.last.data[:samples]

          dfs_postorder[0..-2].each do |parent_node|
            parent_data = parent_node.data
            parent_node.nested.each_value do |child_node|
              child_data = child_node.data

              child_data[:global_percentage] = 100.0 * child_data[:samples] / root_samples
              child_data[:local_percentage] = 100.0 * child_data[:samples] / parent_data[:samples]
            end
          end
        end

        node_comparator do |data_a, data_b|
          data_b[:samples] <=> data_a[:samples]
        end
      end
    end
  end
end
