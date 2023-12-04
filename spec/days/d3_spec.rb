# frozen_string_literal: true

require_relative '../../days/d3'

describe Days::D3 do
  let(:lines) do
    [
      '467..114..',
      '...*.....#',
      '..35..633.',
      '......#...',
      '617*......',
      '.....+.58.',
      '..592.....',
      '......755.',
      '...$.*....',
      '.664.598..'
    ]
  end

  describe '#part1' do
    subject { described_class.new(lines).part1 }

    let(:expected) { 4361 }

    it { is_expected.to eq(expected) }
  end

  describe '#part2' do
    subject { described_class.new(lines).part2 }

    let(:expected) { 467_835 }

    it { is_expected.to eq(expected) }
  end
end
