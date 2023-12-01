require_relative 'base'

module Days
  # https://adventofcode.com/2023/day/1
  class D1 < Base
    WORD_TO_DIGIT = {
      'one' => 1, 'two' => 2, 'three' => 3, 'four' => 4,
      'five' => 5, 'six' => 6, 'seven' => 7, 'eight' => 8,
      'nine' => 9
    }

    def self.p1(lines)
      lines.sum do |line|
        first = line.chars.find { |c| c =~ /\d/ }
        last = line.chars.reverse.find { |c| c =~ /\d/ }

        [first, last].join.to_i
      end
    end

    def self.p2(lines)
      p1(collapse_digits(lines))
    end

    # Collapses all strings to their digits, either as
    # digit literals (1, 2, 3) or words (one, two, three)
    #
    # @param lines [Array<String>]
    # @return [Array<String>]
    def self.collapse_digits(lines)
      lines.map { |line| extract_digits(line).join }
    end

    # Extracts all digits from a line, either
    # as digit literals (1, 2, 3) or words (one, two, three)
    #
    # @param line [String]
    # @return [Array<String>]
    def self.extract_digits(line)
      line.length.times.each_with_object([]) do |i, acc|
        next acc << line[i] if line[i] =~ /\d/

        WORD_TO_DIGIT.each do |k, d|
          if line[i...(i + k.length)] == k
            acc << d
            break
          end
        end

        acc
      end
    end

    private_class_method :p1, :p2, :collapse_digits, :extract_digits
  end
end
