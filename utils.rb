# frozen_string_literal: true

module Utils
  def self.load(day, test: false)
    filename = "input/d#{day}#{test ? '_test' : ''}.txt"
    File.readlines(filename).map(&:strip)
  end
end
