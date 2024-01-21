# frozen_string_literal: true

require 'test_helper'

class Game < ApplicationRecord
  class StartTest < ActiveSupport::TestCase
    test 'creates a new game and time' do
      assert_nil Game.first

      game = Game::Start.call
      time = Game::Time.where(game:, current: 0)

      assert_equal 1, Game.count
      assert time
    end
  end
end
