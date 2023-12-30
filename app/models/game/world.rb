class Game::World < ApplicationRecord
  PATTERN_DEADLY = 'x'.freeze

  WIDTH = 40

  Lane = Data.define(:pattern, :speed)
  Spawn = Class.new(Lane)
  Railway = Class.new(Lane)

  LEVELS = [
    Spawn.new(pattern: '........................................', speed: 0),
    Lane.new(pattern: '..x.....................................', speed: 10),
    Lane.new(pattern: '..x.....................................', speed: 20),
    Lane.new(pattern: '..x.....................................', speed: 30),
    Lane.new(pattern: '..x.....................................', speed: 40),
    Lane.new(pattern: '..x.....................................', speed: 50),
    Lane.new(pattern: '..x.....................................', speed: 60),
    Lane.new(pattern: '..x.....................................', speed: 70),
    Lane.new(pattern: '..x.....................................', speed: 80),
    Railway.new(pattern: '========================================',speed: 0)
  ].freeze

  INITIAL_LEVEL = 0
  INITIAL_POSITION = 2
  MAX_LEVEL = LEVELS.count - 1

  def progress(timestamp)
    rotations.each_with_index do |rotation, index|
      next unless rotate_level?(index, timestamp)

      rotations[index] = rotation >= WIDTH ? 0 : rotation + 1
    end
  end

  def safe_at?(index, position)
    pattern = LEVELS[index].pattern
    rotation = rotations[index]

    pattern[position + rotation] != PATTERN_DEADLY
  end

  private

  def rotate_level?(index, timestamp)
    speed = LEVELS[index].speed

    return false if speed.zero?

    (timestamp % speed).zero?
  end
end
