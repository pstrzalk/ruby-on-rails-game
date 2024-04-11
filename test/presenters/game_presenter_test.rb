# frozen_string_literal: true

require 'test_helper'

class Game < ApplicationRecord
  class GamePresenterTest < ActiveSupport::TestCase
    test 'returns true if player is at the cell' do
      game = Game.construct
      game.join(SecureRandom.uuid)
      player = game.players.last
      player.position_vertical = 1
      player.position_horizontal = 3

      presenter = GamePresenter.new(game:)

      assert presenter.player_at?(11, 3)
    end

    test 'returns false if player is not at the cell' do
      game = Game.construct

      presenter = GamePresenter.new(game:)

      assert_not presenter.player_at?(4, 4)
    end
  end
end
