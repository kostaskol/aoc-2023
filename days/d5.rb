# frozen_string_literal: true

require 'pry'
require 'byebug'
require_relative 'base'

module Days
  class D5 < Base
    def part1
      inp = parsed_lines

      inp['seeds'].map do |seed|
        loc = nil
        curr_map = inp.keys.find { |k| k != 'seeds' && k.start_with?('seed') }
        curr_val = seed

        until curr_map.nil?
          map =
            inp[curr_map].find do |tmp_map|
              tmp_map[:src].cover?(curr_val)
            end

          unless map.nil?
            offset = curr_val - map[:src].begin
            curr_val = map[:dst].begin + offset
          end

          dst_map_suffix = curr_map.split('-to-').last
          if dst_map_suffix == 'location'
            loc = curr_val
            break
          end

          curr_map = inp.keys.find { |k| k.start_with?(dst_map_suffix) }
        end

        loc
      end.min
    end

    def part2
      inp = parsed_lines
      loc = nil

      seed_ranges = inp['seeds'].each_slice(2).map do |(start, range)|
        (start..(start + range))
      end

      curr_map = inp.keys.find { |k| k != 'seeds' && k.start_with?('seed') }

      seed_ranges.map do |range|
        curr_range = [range]

        until curr_map.nil?
          curr_range = mapped_to_next(curr_range, inp[curr_map])

          dst_map_suffix = curr_map.split('-to-').last
          if dst_map_suffix == 'location'
            loc = curr_range.min_by(&:begin).begin
            break
          end

          curr_map = inp.keys.find { |k| k.start_with?(dst_map_suffix) }
        end

        loc
      end.min
    end

    def part2_brute
      inp = parsed_lines

      inp['seed'] = inp.delete('seeds').each_slice(2).map do |(start, range)|
        (start..(start + range))
      end

      locs = inp['humidity-to-location'].map do
        _1[:dst]
      end.sort_by { _1.begin }

      locs.each do |loc|
        loc.each do |i|
          print "\r#{i}"
          curr_val = i
          curr_map = inp.keys.find { |k| k.end_with?('location') }

          until curr_map == 'seed'
            map =
              inp[curr_map].find do |tmp_map|
                tmp_map[:dst].cover?(curr_val)
              end

            unless map.nil?
              offset = curr_val - map[:dst].begin
              curr_val = map[:src].begin + offset
            end

            dst_map_prefix = curr_map.split('-to-').first

            curr_map = inp.keys.find { |k| k.end_with?(dst_map_prefix) }
          end


          if inp['seed'].any? { |range| range.cover?(curr_val) }
            return i
          end
        end
      end
    end

    private

    def parsed_lines
      curr_key = nil

      @lines.each_with_object({}) do |line, acc|
        if line.empty?
          curr_key = nil
          next
        end

        unless curr_key.nil?
          dst, source, count = line.split(' ').map(&:to_i)

          source_range = (source..(source + count - 1))
          dst_range = (dst..(dst + count - 1))
          acc[curr_key] ||= []
          acc[curr_key] << { src: source_range, dst: dst_range }
          next
        end

        parts = line.split(':')
        if parts.first == 'seeds'
          acc['seeds'] = parts.last.split(' ').map(&:to_i)
          next
        end

        parts = line.split(' ')
        curr_key = parts.first
      end
    end

    def overlap?(range1, range2)
      range1.begin <= range2.end && range1.end >= range2.begin
    end

    def mapped_to_next(ranges, maps)
      rem = ranges.dup
      acc = []

      while (range = rem.pop)
        overlapping =
          maps.select do |map|
            overlap?(range, map[:src])
          end.sort_by { _1[:src].begin }

        next acc << range unless overlapping.any?

        raw = [range]

        overlapping.each do |ol|
          new_raw = []
          raw.each do |r|
            mapped = mapped_range(r, ol[:src], ol[:dst])

            acc += mapped[:mapped]
            new_raw += mapped[:raw]
          end
          raw = new_raw
        end

        acc += raw
      end

      acc
    end

    def mapped_range(range, source, dest)
      if source.cover?(range)
        return {
          mapped: [mapped(range.begin, source, dest)..mapped(range.end, source, dest)],
          raw: []
        }
      end

      ranges = {
        mapped: [],
        raw: []
      }

      if range.begin <= source.begin
        ranges[:raw] << (range.begin..(source.begin - 1)) if range.begin != source.begin

        start = mapped(source.begin, source, dest)
        fin = mapped(source.end, source, dest)
        ranges[:mapped] << (start..fin)

        ranges[:raw] << ((source.end + 1)..range.end) if range.end > source.end
      elsif range.end >= source.end
        start = mapped(range.begin, source, dest)
        fin = mapped(source.end, source, dest)
        ranges[:mapped] << (start..fin)

        ranges[:raw] << ((source.end + 1)..range.end)
      end

      ranges.transform_values { _1.sort_by(&:begin) }
    end

    def mapped(val, source, dest)
      offset = val - source.begin
      dest.begin + offset
    end
  end
end
