# frozen_string_literal: true

require 'test_helper'

class Game < ApplicationRecord
  class ProgressTest < ActiveSupport::TestCase
    test 'progresses game time' do
      game = Game::Start.call
      time = Game::Time.find_by(game:)

      timestamp_before = time.current

      Game::Progress.call(game)

      time.reload
      timestamp_after = time.current

      assert_equal timestamp_before + 1, timestamp_after
    end

    test 'consumes game actions' do
      game = Game::Start.call
      action = Game::Action.create(game_id: game.id, data: {})

      Game::Progress.call(game)

      assert_equal game.last_action_id, action.id
    end
  end
end
