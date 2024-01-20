# frozen_string_literal: true

require 'test_helper'

class Game < ApplicationRecord
  class PlayerTest < ActiveSupport::TestCase
    test 'kill should set alive to false' do
      player = Player.new(alive: true)
      player.kill

      assert_not player.alive
    end

    test 'move_left should decrease position_horizontal by 1' do
      player = Player.new(position_horizontal: 3)
      player.move_left

      assert_equal 2, player.position_horizontal
    end

    test 'move_right should increase position_horizontal by 1' do
      player = Player.new(position_horizontal: 3)
      player.move_right

      assert_equal 4, player.position_horizontal
    end

    test 'move_forward should increase position_vertical by 1' do
      player = Player.new(position_vertical: 2)
      player.move_forward

      assert_equal 3, player.position_vertical
    end

    test 'move_back should decrease position_vertical by 1' do
      player = Player.new(position_vertical: 2)
      player.move_back

      assert_equal 1, player.position_vertical
    end
  end
end
