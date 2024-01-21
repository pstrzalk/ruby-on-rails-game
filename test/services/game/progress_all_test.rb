# frozen_string_literal: true

require 'test_helper'

class Game < ApplicationRecord
  class ProgressAllTest < ActiveSupport::TestCase
    test 'progresses all running games' do
      game1 = Start.call
      game2 = Start.call

      TRAIN_MOVES_EVERY.times { ProgressAll.call }
      game1.reload
      game1.update(finished_at: ::Time.current)

      TRAIN_MOVES_EVERY.times { ProgressAll.call }

      game1.train_position = 1
      game2.train_position = 2
    end
  end
end
