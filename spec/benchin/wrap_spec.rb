RSpec.describe Benchin::Wrap do
  subject(:instance) { described_class.new(name) }

  let(:name) { 'REPORT NAME' }
  let(:report) { instance.report }

  before do
    allow(report).to receive(:add_time)
  end

  describe '#call' do
    context 'when used in 2 places without nesting and code executed twice' do
      subject(:code_execution) do
        2.times do
          instance.call('AAA') do
            10.times { Math.sqrt(12_345) }
          end

          instance.call('BBB') do
            10.times { Math.sqrt(12_345) }
          end
        end
      end

      it 'registers 4 records' do
        expect(report).to receive(:add_time).exactly(4).times

        code_execution
      end

      it 'registers 1st wrpapped block time twice' do
        expect(report).to receive(:add_time).with(['AAA'], Float).twice

        code_execution
      end

      it 'registers 2nd wrpapped block time twice' do
        expect(report).to receive(:add_time).with(['BBB'], Float).twice

        code_execution
      end
    end

    context 'when used in 2 places with nesting and code executed twice' do
      subject(:code_execution) do
        2.times do
          instance.call('AAA') do
            10.times do
              Math.sqrt(12_345)
              instance.call('BBB') do
                10.times { Math.sqrt(12_345) }
              end
            end
          end

          instance.call('BBB') do
            10.times { Math.sqrt(12_345) }
          end
        end
      end

      it 'registers 24 records' do
        expect(report).to receive(:add_time).exactly(24).times

        code_execution
      end

      it 'registers 1st wrpapped block time twice' do
        expect(report).to receive(:add_time).with(['AAA'], Float).twice

        code_execution
      end

      it 'registers 2nd wrpapped block time twice' do
        expect(report).to receive(:add_time).with(['BBB'], Float).twice

        code_execution
      end

      it 'registers nested wrpapped block time 20 times' do
        expect(report).to receive(:add_time).with(%w[AAA BBB], Float).exactly(20).times

        code_execution
      end
    end
  end

  describe '#reset' do
    subject(:reset) { instance.reset }

    it 'resets report' do
      expect { reset }.to(change { instance.report.object_id })
    end
  end
end
