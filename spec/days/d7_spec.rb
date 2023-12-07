# frozen_string_literal: true

require_relative '../../days/d7'

describe Days::D7 do
  let(:lines) do
    [
      '32T3K 765',
      'T55J5 684',
      'KK677 28',
      'KTJJT 220',
      'QQQJA 483'
    ]
  end

  describe '#part1' do
    subject { described_class.new(lines).part1 }

    let(:expected) { 6440 }

    it { is_expected.to eq(expected) }
  end

  describe '#part2' do
    subject { described_class.new(lines).part2 }

    let(:expected) { 5905 }

    it { is_expected.to eq(expected) }
  end
end
