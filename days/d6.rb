# frozen_string_literal: true

require_relative 'base'

module Days
  # https://adventofcode.com/2023/day/6
  class D6 < Base
    def part1
      race!(races)
    end

    def part2
      race!([conjoined_race])
    end

    private

    # Brute force but runs in a few seconds for p2 ¯\_(ツ)_/¯
    def race!(races)
      races.reduce(1) do |acc, race|
        reached = false
        times_reached =
          (race[:time] + 1).times.reduce(0) do |sum, time|
            if distance_covered(time, race[:time]) > race[:distance]
              reached = true
              next sum + 1
            end

            # If we've reached the distance once and now stopped reaching it, we've gone over
            # the maximum time we can hold the button so we cut it early
            # Not necessary but shaves off ~2s on part 2
            break sum if reached

            sum
          end

        acc * times_reached
      end
    end

    # Returns the distance covered in the remaining time if `charge_time` is spent
    # pressing the button
    #
    # @return [Integer]
    def distance_covered(charge_time, overall_time) = (overall_time - charge_time) * charge_time

    # Returns an array of hashes, each of which containing
    # the time & distance of a race
    #
    # @return [Array<Hash<Symbol, Integer>>]
    def races
      @lines.each_with_object([]) do |line, acc|
        line_name, nums = line.split(':')
        line_name = line_name.downcase.to_sym

        nums.split(' ').each_with_index do |num, index|
          acc[index] ||= {}
          acc[index][line_name] = num.to_i
        end
      end
    end

    # Returns a hash of the time & distance of the race
    # by joining all the numbers in each line
    # (e.g. 3 42 84 -> 34_284)
    #
    # @return [Hash<Symbol, Integer>]
    def conjoined_race
      @lines.each_with_object({}) do |line, acc|
        line_name, nums = line.split(':')
        line_name = line_name.downcase.to_sym

        acc[line_name] = nums.split(' ').join.to_i
      end
    end
  end
end

