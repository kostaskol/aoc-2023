# frozen_string_literal: true

require_relative 'base'

module Days
  # https://adventofcode.com/2023/day/8
  class D8 < Base
    def part1
      count = 0
      i = 0
      curr_val = 'AAA'
      loop do
        dir = parsed_lines[:instr][i]
        curr_val = parsed_lines[:maps][curr_val][dir.downcase.to_sym]

        i += 1
        count += 1

        next unless i == parsed_lines[:instr].length

        return count if curr_val == 'ZZZ'

        i = 0
      end
    end

    def part2
      start_nodes = parsed_lines[:maps].keys.select { |k| k.end_with?('A') }

      counts =
        start_nodes.map do |node|
          count = 1
          i = 0
          curr_val = node

          loop do
            dir = parsed_lines[:instr][i]

            curr_val = parsed_lines[:maps][curr_val][dir.downcase.to_sym]

            break if curr_val.end_with?('Z')

            count += 1
            i += 1
            i = 0 if i == parsed_lines[:instr].length
          end

          count
        end

      counts.reduce(1, &:lcm)
    end

    private

    def parsed_lines
      return @parsed_lines if defined?(@parsed_lines)

      instr = @lines.first.chars

      maps =
        @lines.each_with_object({}) do |line, map|
          next if line.empty? || !line.include?('=')

          src, dsts = line.split(' = ')
          md = /(\w{3}), (\w{3})/.match(dsts)

          map[src] = { l: md[1], r: md[2] }
        end

      @parsed_lines = { instr:, maps: }
    end
  end
end
