# frozen_string_literal: true

require_relative 'base'

module Days
  # https://adventofcode.com/2023/day/2
  class D2 < Base
    def part1
      parsed_game.reduce(0) do |sum, (id, rounds)|
        possible_game?(rounds) ? sum + id : sum
      end
    end

    def part2
      parsed_game.reduce(0) do |sum, (_, rounds)|
        min_cubes = min_cubes(rounds)

        sum + min_cubes.values.reduce(:*)
      end
    end

    private

    # Parses a string like
    # `Game <id>: <color1> <number1>[[, <color2> <number2>, ...]; <color1> <number1>[, <color2> <number2>, ...]]
    # into a game id to revealed cubes (per round) hash
    # e.g.
    # {
    #   id1 => [{ red: 1, green: 2, blue: 3 }, { red: 4, green: 5, blue: 6 }],
    #   ...
    # }
    #
    # @return [Hash<Integer, Array<Hash<String, Integer>>>]
    def parsed_game
      @lines.to_h do |line|
        game, results = line.split(': ')

        id = game.split(' ').last.to_i

        reveals = results.split(';').map { |res| parsed_set(res) }

        [id, reveals]
      end
    end

    # Parses a single revealed set of cubes and returns a hash
    # mapping the color to number
    #
    # @return [Hash<String, Integer>]
    def parsed_set(result)
      result.split(',').each_with_object({}) do |cube, acc|
        number, color = cube.split(' ')

        acc[color] = number.to_i
      end
    end

    # Determines whether the provided game is possible or not, based
    # on the max number of cubes of each color available.
    # The maximum number of cubes is defined in the problem statement
    #
    # @return [Boolean]
    def possible_game?(game)
      max_cubes = { red: 12, green: 13, blue: 14 }

      game.each do |round|
        round.each do |color, number|
          return false if number > max_cubes[color.to_sym]
        end
      end

      true
    end

    # Determines the minimum number of cubes of each color that
    # would be required for the game to be possible
    # (i.e. the max number of cubes shown simultaneously)
    #
    # @return [Hash<String, Integer>]
    def min_cubes(game)
      game.each_with_object({ red: 0, green: 0, blue: 0 }) do |round, acc|
        round.each do |color, number|
          acc[color.to_sym] = number if number > acc[color.to_sym]
        end
      end
    end
  end
end
