# frozen_string_literal: true

require 'test_helper'

class Game < ApplicationRecord
  class WorldTest < ActiveSupport::TestCase
    test 'safe_at? should return true when position is safe' do
      world = World.construct

      assert world.safe_at?(0, 0)
    end

    test 'safe_at? should return false when position contains TNT' do
      world = World.construct

      assert_not world.safe_at?(2, 0)
    end

    test 'progress should update rotations for lanes with moves_every' do
      world = World.construct
      11.times { world.progress(_1) }

      assert_equal [0, 4, 3, 3, 3, 6, 2, 6, 0], world.rotations
    end
  end
end
