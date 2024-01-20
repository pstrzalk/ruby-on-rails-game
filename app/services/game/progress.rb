# frozen_string_literal: true

class Game < ApplicationRecord
  class Progress
    def self.call(game)
      time = Game::Time.find_by(game:)
      time.progress
      time.save!

      timestamp = time.current
      actions = Game::Action.pending_for_game(game)

      game.save if game.progress(timestamp:, actions:)
    end
  end
end
