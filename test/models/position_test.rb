# frozen_string_literal: true

require 'test_helper'

class PositionTest < ActiveSupport::TestCase
  test 'is equal' do
    assert_equal Position.new(1, 2), Position.new(1, 2)
  end

  test 'is different' do
    assert_not_equal Position.new(1, 2), Position.new(7, 4)
  end
end
