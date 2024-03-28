# frozen_string_literal: true

require 'test_helper'

class Game < ApplicationRecord
  class GamePresenterTest < ActiveSupport::TestCase
    test 'returns game world rows' do
      game = Game.construct
      presenter = GamePresenter.new(game:)

      expected_rows = [
        %w[= = = = = = = = = = = = = = = = = = = = = = = = = = = = =],
        %w[. . . . . . . . . . . . . . . . . . V . . . . . . . . . . .],
        %w[. . V V . . . . . . . . . . . . . . . . . . . . . . . . . .],
        %w[. . . . . . . . . . . . . . B B V V . . . . . . . . . . . .],
        %w[N . . . . . . . . . . . . . . . . . . . . . . . . . . . . .],
        %w[. . . V B . . . . . . . . . . . . . . . . . . . . . . . . .],
        %w[B N . . . . . . . . . . . . B N B . . . . . . . . N G G N .],
        %w[. . V V . . . . . . . . . . . . . V B B . . . . . . . . . .],
        %w[. . . . . . . . . . . . . . . . . . . . . . . N . . . . . .],
        %w[. . . . . . . . . . . . . . . . . . . G G . . . . . N N . .],
        %w[N . . . . . . . . . . . . . . . . . . . . . . N . N B N . .],
        %w[. . . . . . . . . . . . . . N V G V N V G V . . . . . . . .],
        %w[- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -]
      ]

      assert_equal expected_rows, presenter.rows
    end

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
