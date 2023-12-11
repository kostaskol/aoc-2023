# frozen_string_literal: true

require_relative 'base'

module Days
  # https://adventofcode.com/2023/days/9
  class D9 < Base
    def part1
      @lines.reduce(0) do |sum, line|
        tmp_lines = zeroed_line(parsed_line(line))

        i = tmp_lines.length - 1

        while i.positive?
          val = tmp_lines[i].last + tmp_lines[i - 1].last
          tmp_lines[i - 1] << val

          i -= 1
        end

        sum + tmp_lines.first.last
      end
    end

    def part2
      @lines.reduce(0) do |sum, line|
        tmp_lines = zeroed_line(parsed_line(line))

        i = tmp_lines.length - 1

        while i.positive?
          val = tmp_lines[i - 1].first - tmp_lines[i].first
          tmp_lines[i - 1].insert(0, val)

          i -= 1
        end

        sum + tmp_lines.first.first
      end
    end

    private

    def zeroed_line(line)
      tmp_lines = [line]

      until tmp_lines.last.all?(0)
        tmp_lines << []

        tmp_lines[-2].each_cons(2).each do |(first, second)|
          tmp_lines[-1] << (second - first)
        end
      end

      tmp_lines
    end

    def parsed_line(line) = line.split(' ').map(&:to_i)
  end
end
