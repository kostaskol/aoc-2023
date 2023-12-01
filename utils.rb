# frozen_string_literal: true

def load(day, test: false)
  filename = "input/d#{day}#{test ? '_test' : ''}.txt"
  File.readlines(filename).map(&:strip)
end
