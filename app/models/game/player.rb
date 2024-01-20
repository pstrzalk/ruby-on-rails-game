# frozen_string_literal: true

class Game < ApplicationRecord
  class Player < ApplicationRecord
    broadcasts_to ->(player) { "game_player_#{player.id}" }

    belongs_to :game

    def kill
      self.alive = false
    end

    def move_left
      self.position_horizontal -= 1
    end

    def move_right
      self.position_horizontal += 1
    end

    def move_forward
      self.position_vertical += 1
    end

    def move_back
      self.position_vertical -= 1
    end
  end
end
