RSpec.describe Benchin::Wrap::Report do
  subject(:instance) { described_class.new(name) }

  let(:name) { 'REPORT_NAME' }

  describe '#add_time' do
    context 'with one-level path' do
      before do
        instance.add_time(['TOP'], 15.0)
      end

      let(:expected_to_h) do
        {
          name: name,
          total_seconds: 15.0,
          nested: [
            {
              name: 'TOP',
              total_seconds: 15.0,
              self_seconds: 15.0,
              child_seconds: 0.0,
              calls: 1,
              nested: []
            }
          ]
        }
      end

      it 'builds correct data' do
        expect(instance.to_h).to eq(expected_to_h)
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
        {
          name: name,
          total_seconds: 22.0,
          nested: [
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
        }
      end

      it 'builds correct data' do
        expect(instance.to_h).to eq(expected_to_a)
      end
    end
  end

  describe '#to_h' do
    subject(:invoke) { instance.to_h }

    context 'when report is empty' do
      it do
        expect(invoke).to eq(
          name: name,
          total_seconds: 0.0,
          nested: []
        )
      end
    end
  end
end
