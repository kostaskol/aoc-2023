# frozen_string_literal: true

require_relative 'base'

module Days
  # https://adventofcode.com/2023/days/7
  class D7 < Base
    HANDS = {
      'five_of' => 7,
      'four_of' => 6,
      'full_house' => 5,
      'three_of' => 4,
      'two_pair' => 3,
      'pair' => 2,
      'high_card' => 1
    }.freeze

    VALUES_PART1 = {
      **((2..9).to_h { [_1.to_s, _1] }),
      'T' => 10,
      'J' => 11,
      'Q' => 12,
      'K' => 13,
      'A' => 14
    }.freeze

    VALUES_PART2 = VALUES_PART1.merge(
      'J' => 0
    ).freeze

    def part1
      @part = 1
      run
    end

    def part2
      @part = 2
      run
    end

    private

    def run
      hands = ranks.keys

      hands = hands.sort { cmp(_1, _2) }

      hands.map.with_index(1) do |hand, indx|
        indx * ranks[hand]
      end.sum
    end

    def ranks = @lines.to_h { |line| line.split(' ') }.transform_values(&:to_i)

    def cmp(hand1, hand2)
      if score(hand1) > score(hand2)
        1
      elsif score(hand2) > score(hand1)
        -1
      else
        hand1.chars.each_with_index do |card, indx|
          next if card == hand2[indx]

          return cmp_cards(card, hand2[indx])
        end
      end
    end

    def score(hand)
      # For part 1, `J` acts normally
      if hand.chars.include?('J') && @part == 2
        count_js(hand)
      else
        count_normals(hand)
      end
    end

    def count_normals(hand)
      counts = hand.chars.tally.values

      if counts.include?(5)
        HANDS['five_of']
      elsif counts.include?(4)
        HANDS['four_of']
      elsif counts.include?(3) && counts.include?(2)
        HANDS['full_house']
      elsif counts.include?(3)
        HANDS['three_of']
      elsif counts.count(2) == 2
        HANDS['two_pair']
      elsif counts.count(2) == 1
        HANDS['pair']
      else
        HANDS['high_card']
      end
    end

    def count_js(hand)
      counts = hand.chars.tally.values

      case hand.chars.count('J')
      # Both 5 Js & 4 Js leads to a 5-combination hand
      when 5, 4
        HANDS['five_of']
      when 3
        if counts.include?(2)
          HANDS['five_of']
        else
          HANDS['four_of']
        end
      when 2
        if counts.include?(3)
          HANDS['five_of']
        elsif counts.include?(2)
          HANDS['four_of']
        else
          HANDS['three_of']
        end
      when 1
        if counts.include?(4)
          HANDS['five_of']
        elsif counts.include?(3)
          HANDS['four_of']
        elsif counts.include?(2) && counts.count(2) == 2
          HANDS['full_house']
        elsif counts.include?(2)
          HANDS['three_of']
        else
          HANDS['pair']
        end
      end
    end

    def cmp_cards(card1, card2) = values[card1] <=> values[card2]

    def values
      return @values if defined?(@values)

      @values = @part == 1 ? VALUES_PART1 : VALUES_PART2
    end
  end
end
