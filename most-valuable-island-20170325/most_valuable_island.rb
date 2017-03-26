
require 'set'

module MostValuableIsland
  class BreadthFirstSearch
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def find
      mvi = 0
      visited = Set.new

      (0...data.length).each do |y|
        (0...data[y].length).each do |x|
          total = 0
          pending = []
          if data[y][x] != 0 && !visited.include?([y,x])
            pending << [y,x]
          end

          while !pending.empty?
            py, px = pending.shift
            next if py < 0 || px < 0 || py >= data.length || px >= data[py].length
            next if data[py][px] == 0
            next if visited.include? [py,px]
            visited << [py,px]
            total += data[py][px]
            pending << [py-1, px]
            pending << [py+1, px]
            pending << [py, px-1]
            pending << [py, px+1]
          end

          mvi = (total > mvi ? total : mvi)
        end
      end
      mvi
    end
  end
end

ISLAND1 = [[ 0,  1, 2, 3, 0],
           [ 1,  2, 0, 0, 0],
           [ 0,  0, 0, 0, 0],
           [ 10, 0, 0, 0, 0]]

[
  MostValuableIsland::BreadthFirstSearch
].each do |algo|
  value = algo.new(ISLAND1).find
  raise "Expected 10, got #{value}" unless value == 10
end
