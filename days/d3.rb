# frozen_string_literal: true

require_relative 'base'

module Days
  class D3 < Base
    def part1
      part_numbers = []

      matrix.each_with_index do |row, row_indx|
        part_numbers += parse_line(row, row_indx)
      end

      part_numbers.sum
    end

    def part2
      gear_ratios = []

      matrix.each_with_index do |row, row_indx|
        row.each_with_index do |val, col_indx|
          next unless val == '*'

          adjascent_nums = adjascent_nums(matrix, row_indx, col_indx)
          next if adjascent_nums.nil?

          gear_ratios << adjascent_nums.reduce(1) do |acc, indx|
            acc * consume_num_at(matrix, *indx)
          end
        end
      end

      gear_ratios.sum
    end

    private

    def parse_line(row, row_indx)
      part_numbers = []
      num = []
      is_part_number = false

      row.each_with_index do |val, col_indx|
        if val =~ /\d/
          num << val
          is_part_number ||= adjascent_to_sym?(matrix, neighbours(matrix, row_indx, col_indx))
        else
          if is_part_number
            next if num.empty?

            part_numbers << num.join.to_i
          end

          is_part_number = false
          num = []
        end
      end

      # Handle last number of line
      part_numbers << num.join.to_i if is_part_number && !num.empty?
    end

    def consume_num_at(matrix, i, j)
      raise 'boom' unless matrix[i][j] =~ /\d/

      acc = [matrix[i][j]]

      curr_j = j - 1
      while curr_j >= 0 && matrix[i][curr_j] =~ /\d/
        acc.insert(0, matrix[i][curr_j])
        curr_j -= 1
      end

      curr_j = j + 1
      while curr_j < matrix[0].length && matrix[i][curr_j] =~ /\d/
        acc << matrix[i][curr_j]
        curr_j += 1
      end

      acc.join.to_i
    end

    def matrix
      @lines.map(&:chars)
    end

    def neighbours(matrix, i, j)
      [[i, j - 1], [i, j + 1],
       [i - 1, j - 1], [i - 1, j],
       [i - 1, j + 1], [i + 1, j - 1],
       [i + 1, j], [i + 1, j + 1]].select do |h, w|
        h.between?(0, matrix.length - 1) && w.between?(0, matrix.first.length - 1)
      end
    end

    def adjascent_to_sym?(matrix, neighbours)
      neighbours.any? { |i, j| !(matrix[i][j] =~ /\d/ || matrix[i][j] == '.') }
    end

    # Not my proudest moment, not my least
    # proud either ¯\_(ツ)_/¯
    def adjascent_nums(matrix, curr_i, curr_j)
      indices = []
      [curr_i - 1, curr_i, curr_i + 1].each do |i|
        subrow = matrix[i][(curr_j - 1)..(curr_j + 1)].join('')

        # Trivial cases
        next if ['...', '.*.'].include?(subrow)

        if subrow =~ /(\d\.\d|\d\*\d)/
          indices << [i, curr_j - 1]
          indices << [i, curr_j + 1]
        else
          # e.g.
          # subrow = ..2
          # curr_j = 5
          # subrow.index(/\d/) = 2 (relative index)
          # (curr_j - 1) (the absolute index of the first `.`) + relative index
          # =
          # the absolute index of the digit in the matrix
          indices << [i, (curr_j - 1 + subrow.index(/\d/))]
        end
      end

      return if indices.count != 2

      indices
    end
  end
end
