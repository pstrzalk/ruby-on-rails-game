class Game::World < ApplicationRecord
  PATTERN_TNT = 'N'.freeze
  PATTERN_GRAVEL = '-'.freeze
  PATTERN_RAILWAY = '='.freeze

  WIDTH = 30

  Lane = Data.define(:pattern, :speed)
  Spawn = Class.new(Lane)
  Railway = Class.new(Lane)

  LEVELS = [
    Spawn.new(pattern:   '------------------------------', speed: 0),
    Lane.new(pattern:    '..............NNNNNNNN........', speed: 3),
    Lane.new(pattern:    '.......................N.N.N..', speed: 5),
    Lane.new(pattern:    'NN.................NN.....NN..', speed: 5),
    Lane.new(pattern:    '.......................N......', speed: 5),
    Lane.new(pattern:    '..NNNNNN......NNN.........NNNN', speed: 2),
    Lane.new(pattern:    '..NN..........................', speed: 8),
    Lane.new(pattern:    'NN............NNN.........NNNN', speed: 2),
    Railway.new(pattern: '==============================', speed: 0)
  ].freeze

  INITIAL_LEVEL = 0
  INITIAL_POSITION_RANGE = 4..WIDTH-4
  RAILWAY_LEVEL = LEVELS.count - 1

  def progress(timestamp)
    rotations.each_with_index do |rotation, index|
      next unless level_should_rotate?(index, timestamp)

      rotations[index] = rotation >= WIDTH ? 0 : rotation + 1
    end
  end

  def safe_at?(index, position)
    at(index, position) != PATTERN_TNT
  end

  private

  def at(index, position)
    pattern = LEVELS[index].pattern

    row = pattern.split('').rotate(rotations[index])
    row[position]
  end

  def level_should_rotate?(index, timestamp)
    speed = LEVELS[index].speed

    return false if speed.zero?

    (timestamp % speed).zero?
  end
end
