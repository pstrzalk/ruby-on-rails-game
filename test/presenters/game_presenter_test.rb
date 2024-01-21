# frozen_string_literal: true

require 'test_helper'

class Game < ApplicationRecord
  class GamePresenterTest < ActiveSupport::TestCase
    test 'returns game world rows' do
      game = Game.construct
      presenter = GamePresenter.new(game:)

      expected_rows = [
        %w[= = = = = = = = = = = = = = = = = = = = = = = = = = = = =],
        %w[B N . . . . . . . . . . . . B N B . . . . . . . . . N G G N],
        %w[. . V V . . . . . . . . . . . . . . . . . . . . . . . . . .],
        %w[. . N N V V N B . . . . . . B B B . . . . . . . . . N N N N],
        %w[. . . . . . . . . . . . . . . . . . . . . . . N . . . . . .],
        %w[V V G . . . . . . . . . . . . . . . . G G . . . . . N N . .],
        %w[N . . . . . . . . . . . . . . . . . . . . . . N . N B N . .],
        %w[. . . . . . . . . . . . . . N V G V N V G V . . . . . . . .],
        %w[- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -]
      ]

      assert_equal expected_rows, presenter.rows
    end

    test 'returns empty hash when no players' do
      game = Game.construct

      presenter = GamePresenter.new(game:)

      assert_empty(presenter.players_positions)
    end

    test 'returns positions' do
      game = Game.construct
      game.join('00000000-0000-0000-0000-000000000001')
      player1 = game.players.last
      player1.position_horizontal = 2
      player1.position_vertical = 4

      game.join('00000000-0000-0000-0000-000000000002')
      player2 = game.players.last
      player2.position_horizontal = 2
      player2.position_vertical = 4

      game.join('00000000-0000-0000-0000-000000000003')
      player3 = game.players.last
      player3.position_horizontal = 5
      player3.position_vertical = 6

      presenter = GamePresenter.new(game:)

      expected_positions = {
        4 => { 2 => [player1, player2] },
        2 => { 5 => [player3] }
      }

      assert_equal expected_positions, presenter.players_positions
    end
  end
end
