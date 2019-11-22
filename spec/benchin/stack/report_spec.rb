RSpec.describe Benchin::Stack::Report do
  subject(:report) { described_class.new }

  def float_eq(value)
    be_within(0.001).of(value)
  end

  shared_context 'with 1 profile' do
    before do
      report.add_profile(stackprof_data)
    end

    let(:stackprof_data) do
      {
        mode: :cpu,
        interval: 1000,
        samples: 123,
        missed_samples: 10,
        frames: {
          123_001 => {
            name: 'A::B#pow',
            total_samples: 123,
            samples: 100
          },
          123_002 => {
            name: 'A#mult',
            total_samples: 123,
            samples: 23
          }
        }
      }
    end
  end

  shared_context 'with 2 profiles' do
    before do
      report.add_profile(stackprof_data_1)
      report.add_profile(stackprof_data_2)
    end

    let(:stackprof_data_1) do
      {
        mode: :cpu,
        interval: 1000,
        samples: 123,
        missed_samples: 10,
        frames: {
          123_001 => {
            name: 'A::B#pow',
            samples: 100
          },
          123_002 => {
            name: 'A#mult',
            samples: 23
          }
        }
      }
    end

    let(:stackprof_data_2) do
      {
        mode: :cpu,
        interval: 1000,
        samples: 50,
        missed_samples: 0,
        frames: {
          123_001 => {
            name: 'A::B#div',
            samples: 30
          },
          123_002 => {
            name: 'A#mult',
            samples: 20
          }
        }
      }
    end
  end

  describe '#add_profile' do
    context 'when adding one profile' do
      include_context 'with 1 profile'

      let(:expected_hash) do
        {
          samples: 123,
          missed_samples: 10,
          nested: {
            'A' => {
              samples: 123,
              global_percentage: 100.0,
              local_percentage: 100.0,
              nested: {
                'B' => {
                  samples: 100,
                  global_percentage: float_eq(81.3),
                  local_percentage: float_eq(81.3),
                  nested: {
                    '#pow' => {
                      samples: 100,
                      global_percentage: float_eq(81.3),
                      local_percentage: 100.0,
                      nested: {}
                    }
                  }
                },
                '#mult' => {
                  samples: 23,
                  global_percentage: float_eq(18.699),
                  local_percentage: float_eq(18.699),
                  nested: {}
                }
              }
            }
          }
        }
      end

      it 'correctly represents data via #to_h' do
        expect(report.to_h).to match expected_hash
      end
    end

    context 'when adding two profiles' do
      include_context 'with 2 profiles'

      let(:expected_hash) do
        {
          samples: 123 + 50,
          missed_samples: 10,
          nested: {
            'A' => {
              samples: 123 + 50,
              global_percentage: 100.0,
              local_percentage: 100.0,
              nested: {
                'B' => {
                  samples: 100 + 30,
                  global_percentage: float_eq(75.144),
                  local_percentage: float_eq(75.144),
                  nested: {
                    '#pow' => {
                      samples: 100,
                      global_percentage: float_eq(57.803),
                      local_percentage: float_eq(76.923),
                      nested: {}
                    },
                    '#div' => {
                      samples: 30,
                      global_percentage: float_eq(17.341),
                      local_percentage: float_eq(23.076),
                      nested: {}
                    }
                  }
                },
                '#mult' => {
                  samples: 23 + 20,
                  global_percentage: float_eq(24.855),
                  local_percentage: float_eq(24.855),
                  nested: {}
                }
              }
            }
          }
        }
      end

      it 'correctly represents data via #to_h' do
        expect(report.to_h).to match expected_hash
      end
    end
  end

  describe '#to_h' do
    context 'when no profiles added' do
      let(:expected_hash) do
        {
          samples: 0,
          missed_samples: 0,
          nested: {}
        }
      end

      it 'returns correct data structure' do
        expect(report.to_h).to eq expected_hash
      end
    end
  end

  describe '#to_s' do
    subject(:to_s) { report.to_s }

    context 'when no profiles added' do
      it { is_expected.to be_a String }
    end

    context 'when adding one profile' do
      include_context 'with 1 profile'

      it { is_expected.to be_a String }
    end

    context 'when adding two profiles' do
      include_context 'with 2 profiles'

      it { is_expected.to be_a String }
    end
  end
end
