RSpec.describe Benchin do
  it 'has a version number' do
    expect(Benchin::VERSION).not_to be nil
  end

  describe '.wrap' do
    subject(:wrap) { described_class.wrap }

    let(:second_call) { described_class.wrap }

    it { expect(wrap).to be_a(Benchin::Wrap) }

    it 'returns same instance between calls' do
      expect(wrap.object_id).to eq second_call.object_id
    end
  end

  describe '.stack' do
    subject(:stack) { described_class.stack { Math.sqrt(123) } }

    it { expect(stack).to be_a(Benchin::Stack::Report) }
  end
end
