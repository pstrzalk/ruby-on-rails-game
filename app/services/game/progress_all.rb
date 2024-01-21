# frozen_string_literal: true

class Game < ApplicationRecord
  class ProgressAll
    def self.call(**_options)
      Game.running.each do |game|
        Game::Progress.call(game)
      end
    end
  end
end
