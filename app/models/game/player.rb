# frozen_string_literal: true

class Game < ApplicationRecord
  class Player < ApplicationRecord
    broadcasts_to ->(player) { "game_player_#{player.id}" } unless Rails.env.test?

    # composed_of :position,
    #             class_name: 'Position',
    #             mapping: [%w[position_horizontal horizontal], %w[position_vertical vertical]]

    belongs_to :game, touch: true

    def kill
      self.alive = false
    end

    def move_left
      self.position_horizontal -= 1
      # self.position = Position.new(position.horizontal - 1, position.vertical)
    end

    def move_right
      self.position_horizontal += 1
      # self.position = Position.new(position.horizontal + 1, position.vertical)
    end

    def move_forward
      self.position_vertical += 1
      # self.position = Position.new(position.horizontal, position.vertical + 1)
    end

    def move_back
      self.position_vertical -= 1
      # self.position = Position.new(position.horizontal, position.vertical - 1)
    end
  end
end
