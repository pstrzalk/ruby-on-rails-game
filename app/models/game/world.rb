class Game::World < ApplicationRecord
  PATTERN_TNT = 'N'.freeze
  PATTERN_GRAVEL = '-'.freeze
  PATTERN_RAILWAY = '='.freeze

  WIDTH = 40

  Lane = Data.define(:pattern, :speed)
  Spawn = Class.new(Lane)
  Railway = Class.new(Lane)

  LEVELS = [
    Spawn.new(pattern: '----------------------------------------', speed: 0),
    Lane.new(pattern: '..NNNNNNNN..............NNNNNNNN........', speed: 3),
    Lane.new(pattern: '..N.N.N.N........................N.N.N..', speed: 5),
    Lane.new(pattern: '..NNNNNNNNN.....NNNN......NNNNNNNNNNNN..', speed: 2),
    Lane.new(pattern: 'NN......NN...................NN.....NN..', speed: 5),
    Lane.new(pattern: '..NNNNNNNN...............NNNNNNNNNNNNN..', speed: 10),
    Lane.new(pattern: '..........NNNNNNNNNNNNNNNN..............', speed: 8),
    Lane.new(pattern: '..N..............................N......', speed: 5),
    Lane.new(pattern: 'NNN...NNN...............NNN.........NNNN', speed: 2),
    Lane.new(pattern: '..NNNNNNNNNNNNNNNN......NNNNNNNN........', speed: 3),
    Lane.new(pattern: '..N.N.N.N...N.N.N.N...............N.N.N.', speed: 5),
    Lane.new(pattern: '................NNNNNNNNN.NNNNNNNNNNNN..', speed: 2),
    Lane.new(pattern: 'NN......NNNNNNNN.............NN.....NN..', speed: 5),
    Lane.new(pattern: '..NNNNNNNNNNNNNNNN.......NNNNNNNNNNNNN..', speed: 10),
    Lane.new(pattern: '..........NNNN..........................', speed: 8),
    Lane.new(pattern: '..N.............NNNNNNNN.........N......', speed: 5),
    Lane.new(pattern: 'NNN...NNN...............NNN.........NNNN', speed: 2),
    Railway.new(pattern: '========================================', speed: 0)
  ].freeze

  INITIAL_LEVEL = 0
  INITIAL_POSITION = 2
  RAILWAY_LEVEL = LEVELS.count - 1

  def progress(timestamp)
    rotations.each_with_index do |rotation, index|
      next unless level_should_rotate?(index, timestamp)

      rotations[index] = rotation >= WIDTH ? 0 : rotation + 1
    end
  end

  def safe_at?(index, position)
    pattern = LEVELS[index].pattern
    rotation = rotations[index]

    pattern[position + rotation] != PATTERN_TNT
  end

  private

  def level_should_rotate?(index, timestamp)
    speed = LEVELS[index].speed

    return false if speed.zero?

    (timestamp % speed).zero?
  end
end
