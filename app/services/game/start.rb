# frozen_string_literal: true

class Game < ApplicationRecord
  class Start
    def self.call
      game = Game.construct
      game.save!

      time = Game::Time.new(game:, current: 0)
      time.save!

      game
    end
  end
end
