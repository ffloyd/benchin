RSpec.describe Benchin::DataTree do
  shared_context 'when no fields configured' do
    subject(:data_tree) { klass.new }

    let(:klass) do
      Class.new(described_class) do
        node_title_color %i[bright]

        field_space 14
        value_space 7
      end
    end
  end

  shared_context 'with full configuration' do
    subject(:data_tree) { klass.new }

    let(:klass) do
      Class.new(described_class) do
        node_title_color %i[bright]

        field_space 14
        value_space 7

        field :time,
              title: 'Time:',
              default_proc: -> { 0 },
              suffix: 's',
              float_truncate: 3,
              title_color: %i[blue],
              value_color: %i[green bright]

        field :percentage,
              title: 'Percentage:',
              default_proc: -> { 100.0 },
              suffix: '%',
              float_truncate: 2,
              title_color: %i[blue],
              value_color: %i[green],
              child_only: true

        field :gc_time,
              title: 'GC time:',
              default_proc: -> { 0.0 },
              suffix: 's',
              float_truncate: 3,
              title_color: %i[blue],
              value_color: %i[green],
              root_only: true

        on_root_add do |root_data, event|
          root_data[:gc_time] += event[:gc_time]
        end

        on_add do |node_path, event, _is_leaf|
          node_path.each do |node|
            node.data[:time] += event[:time]
          end
        end

        on_aggregate do |root_data, _parent_data, child_data|
          child_data[:percentage] = (child_data[:time] * 100.0) / root_data[:time]
        end

        node_comparator do |a, b|
          a[:time] <=> b[:time]
        end
      end
    end
  end

  describe '#add' do
    context 'with simplest data tree' do
      include_context 'when no fields configured'

      subject(:add) { data_tree.add(%w[A B C], {}) }

      it 'works without errors' do
        expect { add }.not_to raise_exception
      end
    end

    context 'with complex data tree, 2 path additions, 1 root addition' do
      include_context 'with full configuration'

      subject(:add_twice) do
        data_tree.add(%w[A B C], time: 0.1)
        data_tree.add(%w[A B C], time: 0.2)
        data_tree.add_to_root(gc_time: 0.5)
      end

      it 'works without errors' do
        expect { add_twice }.not_to raise_exception
      end
    end
  end

  describe '#to_h' do
    subject(:to_h) { data_tree.to_h }

    context 'with simplest data tree' do
      include_context 'when no fields configured'

      before { data_tree.add(%w[A B C], {}) }

      let(:expected_hash) do
        {
          nested:
          {
            'A' => {
              nested: {
                'B' => {
                  nested: {
                    'C' => {
                      nested: {}
                    }
                  }
                }
              }
            }
          }
        }
      end

      it 'returns exepected hash' do
        expect(to_h).to eq(expected_hash)
      end
    end

    context 'with complex data tree, 2 path additions, 1 root addition' do
      include_context 'with full configuration'

      before do
        data_tree.add(%w[A B D], time: 0.4)
        data_tree.add(%w[A B C], time: 0.6)
        data_tree.add_to_root(gc_time: 0.5)
      end

      let(:expected_hash) do
        {
          time: 1.0,
          gc_time: 0.5,
          nested: {
            'A' => {
              time: 1.0,
              percentage: 100.0,
              nested: {
                'B' => {
                  time: 1.0,
                  percentage: 100.0,
                  nested: {
                    'C' => {
                      time: 0.6,
                      percentage: 60.0,
                      nested: {}
                    },
                    'D' => {
                      time: 0.4,
                      percentage: 40.0,
                      nested: {}
                    }
                  }
                }
              }
            }
          }
        }
      end

      it 'returns exepected hash' do
        expect(to_h).to eq(expected_hash)
      end
    end
  end

  describe '#to_s' do
    subject(:to_s) { data_tree.to_s }

    context 'with simplest data tree' do
      include_context 'when no fields configured'

      before { data_tree.add(%w[A B C], {}) }

      it { expect(to_s).to be_a String }
    end

    context 'with complex data tree, 2 additions, 1 root addition' do
      include_context 'with full configuration'

      before do
        data_tree.add(%w[A B C], time: 0.6)
        data_tree.add(%w[A B D], time: 0.4)
        data_tree.add_to_root(gc_time: 0.5)
      end

      it { expect(to_s).to be_a String }
    end
  end
end
