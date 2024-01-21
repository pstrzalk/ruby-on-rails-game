# frozen_string_literal: true

class Game < ApplicationRecord
  class World < ApplicationRecord
    PATTERN_TNT = 'N'
    PATTERN_GRAVEL = '-'
    PATTERN_RAILWAY = '='
    PATTERN_BLACK_MONSTER = 'B'
    PATTERN_GREEN_MONSTER = 'G'
    PATTERN_VIOLET_MONSTER = 'V'

    PATTERNS_DEADLY = [
      PATTERN_TNT, PATTERN_BLACK_MONSTER, PATTERN_GREEN_MONSTER, PATTERN_VIOLET_MONSTER
    ].freeze

    WIDTH = 30

    Lane = Data.define(:pattern, :moves_every)
    Spawn = Class.new(Lane)
    Railway = Class.new(Lane)

    LEVELS = [
      Spawn.new(pattern:   '------------------------------', moves_every: 0),
      Lane.new(pattern:    '..............NVGVNVGV........', moves_every: 3),
      Lane.new(pattern:    'N......................N.NBN..', moves_every: 5),
      Lane.new(pattern:    'VVG................GG.....NN..', moves_every: 5),
      Lane.new(pattern:    '.......................N......', moves_every: 5),
      Lane.new(pattern:    '..NNVVNB......BBB.........NNNN', moves_every: 2),
      Lane.new(pattern:    '..VV..........................', moves_every: 8),
      Lane.new(pattern:    'BN............BNB.........NGGN', moves_every: 2),
      Railway.new(pattern: '=============================', moves_every: 0)
    ].freeze

    INITIAL_LEVEL = 0
    INITIAL_POSITION_RANGE = 4..WIDTH - 4
    RAILWAY_LEVEL = LEVELS.count - 1

    def self.construct
      instance = Game::World.new
      instance.rotations = Array.new(Game::World::LEVELS.count) { 0 }

      instance
    end

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

      row = pattern.chars.rotate(rotations[index])
      row[position]
    end

    def level_should_rotate?(index, timestamp)
      moves_every = LEVELS[index].moves_every

      return false if moves_every.zero?

      (timestamp % moves_every).zero?
    end
  end
end
