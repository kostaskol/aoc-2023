module Days
  class Base
    def initialize(lines)
      @lines = lines
    end

    def self.solve(part, lines)
      case part.to_i
      when 1
        new(lines).part1
      when 2
        new(lines).part2
      else
        raise "Unknown part #{part}"
      end
    end

    def part1(*)
      raise 'Implement me'
    end

    def part2(*)
      raise 'Implement me'
    end
  end
end
