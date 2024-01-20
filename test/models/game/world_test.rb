# frozen_string_literal: true

require 'test_helper'

class Game < ApplicationRecord
  class WorldTest < ActiveSupport::TestCase
    def setup
      @world = World.construct
    end

    test 'safe_at? should return true when position is safe' do
      assert @world.safe_at?(0, 0)
    end

    test 'safe_at? should return false when position contains TNT' do
      assert_not @world.safe_at?(2, 0)
    end

    test 'progress should update rotations for lanes with moves_every' do
      11.times { @world.progress(_1) }

      assert_equal [0, 4, 3, 3, 3, 6, 2, 6, 0], @world.rotations
    end
  end
end
