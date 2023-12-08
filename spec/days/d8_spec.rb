# frozen_string_literal: true

require_relative '../../days/d8'

describe Days::D8 do
  describe '#part1' do
    subject { described_class.new(lines).part1 }

    context 'when instructions match exactly' do
      let(:lines) do
        [
          'RL',
          '',
          'AAA = (BBB, CCC)',
          'BBB = (DDD, EEE)',
          'CCC = (ZZZ, GGG)',
          'DDD = (DDD, DDD)',
          'EEE = (EEE, EEE)',
          'GGG = (GGG, GGG)',
          'ZZZ = (ZZZ, ZZZ)'
        ]
      end

      let(:expected) { 2 }

      it { is_expected.to eq(expected) }
    end

    context 'when instructions some instruction looping is required' do
      let(:lines) do
        [
          'LLR',
          '',
          'AAA = (BBB, BBB)',
          'BBB = (AAA, ZZZ)',
          'ZZZ = (ZZZ, ZZZ)'
        ]
      end

      let(:expected) { 6 }

      it { is_expected.to eq(expected) }
    end
  end

  describe '#part2' do
    subject { described_class.new(lines).part2 }

    let(:lines) do
      [
        'LR',
        '',
        '11A = (11B, XXX)',
        '11B = (XXX, 11Z)',
        '11Z = (11B, XXX)',
        '22A = (22B, XXX)',
        '22B = (22C, 22C)',
        '22C = (22Z, 22Z)',
        '22Z = (22B, 22B)',
        'XXX = (XXX, XXX)'
      ]
    end

    let(:expected) { 6 }

    it { is_expected.to eq(expected) }
  end
end
