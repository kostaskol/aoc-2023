# frozen_string_literal: true

require_relative 'base'

module Days
  # https://adventofcode.com/2023/day/4
  class D4 < Base
    def part1
      parsed_cards.values.reduce(0) do |sum, nums|
        sum + score(nums[:w], nums[:o])
      end
    end

    def part2
      cardpile = parsed_cards.to_h { |id, _| [id, 1] }

      (1..cardpile.keys.max).each do |id|
        nums = parsed_cards[id]
        match_count = (nums[:w] & nums[:o]).count

        ((id + 1)..(id + match_count)).each do |card|
          break if card > cardpile.keys.max

          # We have cardpile[id] number of cards of id `id`
          # so we'll get that many more
          cardpile[card] += cardpile[id]
        end
      end

      cardpile.values.sum
    end

    private

    # Returns the score of the card.
    # If 0 or 1 matches have been made, the card is scored
    # with that many points.
    # For more than 1 match, the card is scored with 1 point, multiplied by 2
    # for every additional match (so 3 matches are scored 1 * 2 * 2 = 4 points)
    #
    # @param winning [Array<Integer>] the winning numbers
    # @param owned [Array<Integer>] the guessed numbers
    # @return [Integer]
    def score(winning, owned)
      matches = winning & owned

      return 0 if matches.empty?

      2**(matches.count - 1)
    end

    def matches(winning, owned)
      winning & owned
    end

    # Parses the provided lines and returns a hash mapping card ids to
    # the winning and guessed numbers
    #
    # @return [Hash<Integer, Hash<Symbol, Array<Integer>>>]
    def parsed_cards
      return @parsed_cards if defined?(@parsed_cards)

      @parsed_cards =
        @lines.to_h do |line|
          card_id, numbers = line.split(':')
          id = card_id.split(' ').last.to_i

          winning, owned = numbers.split('|')

          [id, { w: winning.split(' ').map(&:to_i), o: owned.split(' ').map(&:to_i) }]
        end
    end
  end
end
