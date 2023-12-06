# frozen_string_literal: true

require_relative '../../days/d6'

describe Days::D6 do
  let(:lines) do
    [
      'Time:      7  15   30',
      'Distance:  9  40  200'
    ]
  end

  describe '#part1' do
    subject { described_class.new(lines).part1 }

    let(:expected) { 288 }

    it { is_expected.to eq(expected) }
  end

  describe '#part2' do
    subject { described_class.new(lines).part2 }

    let(:expected) { 71_503 }

    it { is_expected.to eq(expected) }
  end

end
