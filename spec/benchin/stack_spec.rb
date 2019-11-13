RSpec.describe Benchin::Stack do
  subject(:instance) { described_class.new(mode: mode, interval: interval) }

  let(:mode) { :cpu }
  let(:interval) { 1_000 }

  let(:report) { instance.report }

  before do
    allow(report).to receive(:add_profile)
  end

  describe '#call' do
    context 'when used in 2 places' do
      subject(:code_execution) do
        instance.call do
          10.times { Math.sqrt 12_345 }
        end

        instance.call do
          10.times { Math.sqrt 12_345 }
        end
      end

      it 'registers 2 proile reports' do
        expect(report).to receive(:add_profile).with(Hash).twice

        code_execution
      end
    end
  end
end
