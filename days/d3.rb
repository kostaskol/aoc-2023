# frozen_string_literal: true

require_relative 'base'

module Days
  # https://adventofcode.com/2023/day/3
  class D3 < Base
    def initialize(*)
      super

      @matrix = @lines.map(&:chars)
    end

    def part1
      part_numbers = []

      @matrix.each_with_index do |row, row_indx|
        part_numbers += parse_line(row, row_indx)
      end

      part_numbers.sum
    end

    def part2
      gear_ratios = []

      @matrix.each_with_index do |row, row_indx|
        row.each_with_index do |val, col_indx|
          next unless val == '*'

          adjacent_num_indices = adjacent_num_indices(row_indx, col_indx)
          next if adjacent_num_indices.nil?

          gear_ratios << adjacent_num_indices.reduce(1) do |acc, indx|
            acc * consume_num_around(*indx)
          end
        end
      end

      gear_ratios.sum
    end

    private

    # Parses a single row  and returns an array of the numbers included
    # in that row that are considered part numbers
    # (adjacent to a symbol -- definition in problem statement)
    #
    # @param row [Array<String>]
    # @param row_index [Integer] required to determine each element's neighbours
    # @return [Array<Integer>] The part numbers included in the row
    def parse_line(row, row_index)
      part_numbers = []
      num = []
      is_part_number = false

      row.each_with_index do |val, column_index|
        if val =~ /\d/
          num << val
          is_part_number ||= adjacent_to_sym?(neighbours(row_index, column_index))
        else
          part_numbers << num.join.to_i if is_part_number
          is_part_number = false
          num = []
        end
      end

      # Handle last number of line
      part_numbers << num.join.to_i if is_part_number && !num.empty?

      part_numbers
    end

    # Constructs the number represented by the digits around the given
    # element. Will check both left and right of the element and consume
    # as many digits as possible
    # e.g.
    # 24680
    # consume_num_around(x, y) # where x, y are the coordinates of `6`
    # will consume 2, 4 to the left and 8, 0 to the right,
    # returning 24680
    #
    # @param row_index [Integer] the row index of the first digit
    # @param column_index [Integer] the column index of the first digit
    # @return [Integer]
    def consume_num_around(row_index, column_index)
      raise 'boom' unless @matrix[row_index][column_index] =~ /\d/

      acc = consume_towards!(:left, row_index, column_index)
      acc << [@matrix[row_index][column_index]]
      acc += consume_towards!(:right, row_index, column_index)

      acc.join.to_i
    end

    # Depending on `direction` (:left/:right), consumes as many digits as possible and returns
    # an array of digits. Regardless of the direction, the returned array is sorted correctly
    # e.g.
    # 456
    # consume_towards!(:left, x, y) # where x, y are the coordinates of `6`
    # will return [4, 5, 6]
    #
    # @param direction [Symbol] :left or :right
    # @param row_index [Integer] the row index of the first digit
    # @param column_index [Integer] the column index of the first digit
    # @return [Array<String>] an array of digits
    def consume_towards!(direction, row_index, column_index)
      acc = []

      step, pred =
        if direction == :left
          [:-, ->(curr_column_index) { curr_column_index >= 0 }]
        else
          [:+, ->(curr_column_index) { curr_column_index < @matrix[1].length }]
        end

      curr_column_index = column_index.send(step, 1)
      while @matrix[row_index][curr_column_index] =~ /\d/ && pred.call(curr_column_index)
        acc << @matrix[row_index][curr_column_index]
        curr_column_index = curr_column_index.send(step, 1)
      end

      direction == :left ? acc.reverse : acc
    end

    # Returns all 9 neighbours of the given row and column (diagonals included)
    # No boundary check is performed
    #
    # @param row_index [Integer]
    # @param column_index [Integer]
    def neighbours(row_index, col_index)
      [
        [row_index, col_index - 1],
        [row_index, col_index + 1],
        [row_index - 1, col_index - 1],
        [row_index - 1, col_index],
        [row_index - 1, col_index + 1],
        [row_index + 1, col_index - 1],
        [row_index + 1, col_index],
        [row_index + 1, col_index + 1]
      ]
    end

    # Returns true if any of the neighbours is a symbol
    # (i.e. not a digit or a `.`)
    #
    # @param neighbours [Array<Array<Integer>>]
    # @return [Boolean]
    def adjacent_to_sym?(neighbours)
      neighbours.any? do |i, j|
        next if @matrix[i].nil? || @matrix[i][j].nil?

        !(@matrix[i][j] =~ /\d/ || @matrix[i][j] == '.')
      end
    end

    # Returns the indices of the numbers adjacent to the given
    # element. Only returns the indices if exactly 2 distinct digits (separated by dots)
    # are adjacent
    #
    # e.g.
    # ..2
    # .*.
    # 2..
    # will return the 2 indices as normal
    # However
    # ..2
    # .*.
    # 2.2
    # (or any other combination of multiple distinct digits)
    # will not
    #
    # @param row_index [Integer] The row index of the currently checked element
    # @param column_index [Integer] The column index of the currently checked element
    def adjacent_num_indices(row_index, column_index)
      indices = []
      [row_index - 1, row_index, row_index + 1].each do |i|
        indices += parse_subrow(i, column_index)
      end

      return if indices.count != 2

      indices
    end

    # Parses the subrow (up to 3 characters) and returns the indices
    # where a digit is found. If the digits are consecutive, only
    # the index of the first digit is returned
    # (considered to be a single number)
    #
    # @param curr_row [Integer] The row index of the currently checked element
    # @param curr_col [Integer] The column index of the currently checked element
    # @return [Array<Array<Integer>>] A list of 2-element arrays (row, column)
    def parse_subrow(row_index, column_index)
      subrow = @matrix[row_index][(column_index - 1)..(column_index + 1)].join

      raise 'boom' if subrow.length > 3
      # Trivial cases
      return [] if ['...', '.*.'].include?(subrow)

      if subrow =~ /(\d\.\d|\d\*\d)/
        [[row_index, column_index - 1], [row_index, column_index + 1]]
      else
        # e.g.
        # subrow = ..2
        # curr_j = 5
        # subrow.index(/\d/) = 2 (relative index)
        # (curr_j - 1) (the absolute index of the first `.`) + relative index
        # =
        # the absolute index of the digit in the matrix
        [[row_index, (column_index - 1 + subrow.index(/\d/))]]
      end
    end
  end
end
