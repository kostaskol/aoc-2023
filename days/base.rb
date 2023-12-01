module Days
  class Base
    def self.solve(part, lines)
      case part.to_i
      when 1
        p1(lines)
      when 2
        p2(lines)
      else
        raise "Unknown part #{part}"
      end
    end

    def self.p1(*)
      raise 'Implement me'
    end

    def self.p2(*)
      raise 'Implement me'
    end
  end
end
