# frozen_string_literal: true

class Position
  attr_reader :horizontal, :vertical

  def initialize(horizontal, vertical)
    @horizontal = horizontal
    @vertical = vertical
  end

  def ==(other)
    horizontal == other.horizontal && vertical == other.vertical
  end
end
