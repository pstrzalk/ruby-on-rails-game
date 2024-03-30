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

    def jump
      self.position_vertical += 2

      move_sideways = rand < 0.25
      return unless move_sideways

      if rand < 0.5
        move_left
      else
        move_right
      end
    end

    def move_to(position_horizontal, position_vertical)
      self.position_horizontal = position_horizontal
      self.position_vertical = position_vertical
    end
  end
end
