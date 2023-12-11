# frozen_string_literal: true

require_relative '../../days/d9'

describe Days::D9 do
  let(:lines) do
    [
      '0 3 6 9 12 15',
      '1 3 6 10 15 21',
      '10 13 16 21 30 45'
    ]
  end

  describe '#part1' do
    subject { described_class.new(lines).part1 }

    let(:expected) { 114 }

    it { is_expected.to eq(expected) }
  end

  describe '#part2' do
    subject { described_class.new(lines).part2 }

    let(:expected) { 2 }

    it { is_expected.to eq(expected) }
  end
end
