# frozen_string_literal: true

require_relative '../../days/d1'

describe Days::D1 do
  let(:lines) do
    %w[
      two1nine
      eightwo34three
      abcone2threexyz
      xtwone32four
      4nineeightseven2
      zoneight234
      7pqrst2sixteen
    ]
  end

  describe '#part1' do
    let(:expected) { 237 }

    subject { described_class.new(lines).part1 }

    it { is_expected.to eq(expected) }
  end

  describe '#part2' do
    subject { described_class.new(lines).part2 }

    let(:expected) { 281 }

    it { is_expected.to eq(expected) }
  end
end
