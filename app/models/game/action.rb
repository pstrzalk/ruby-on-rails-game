class Game::Action < ApplicationRecord
  scope :pending_for_game, ->(game) { where(game_id: game.id, id: (game.last_action_id + 1)..).order(id: :asc) }
end
