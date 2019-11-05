RSpec.describe Benchin::Wrap::Report do
  subject(:instance) { described_class.new }

  describe '#add_time' do
    context 'with one-level path' do
      before do
        instance.add_time(['TOP'], 15.0)
      end

      let(:expected_to_a) do
        [
          {
            name: 'TOP',
            total_seconds: 15.0,
            self_seconds: 15.0,
            child_seconds: 0.0,
            calls: 1,
            nested: []
          }
        ]
      end

      it 'builds correct data' do
        expect(instance.to_a).to eq(expected_to_a)
      end
    end

    context 'with nested path' do
      before do
        instance
          .add_time(%w[TOP NESTED], 10.0)
          .add_time(%w[TOP], 10.0)
          .add_time(%w[TOP], 5.0)
          .add_time(%w[NESTED], 7.0)
      end

      let(:expected_to_a) do
        [
          {
            name: 'TOP',
            total_seconds: 15.0,
            self_seconds: 5.0,
            child_seconds: 10.0,
            calls: 2,
            nested: [
              {
                name: 'NESTED',
                total_seconds: 10.0,
                self_seconds: 10.0,
                child_seconds: 0.0,
                calls: 1,
                nested: []
              }
            ]
          },
          {
            name: 'NESTED',
            total_seconds: 7.0,
            self_seconds: 7.0,
            child_seconds: 0.0,
            calls: 1,
            nested: []
          }
        ]
      end

      it 'builds correct data' do
        expect(instance.to_a).to eq(expected_to_a)
      end
    end
  end

  describe '#to_a' do
    subject(:invoke) { instance.to_a }

    context 'when report is empty' do
      it 'returns empty Array' do
        expect(invoke).to eq([])
      end
    end
  end
end
