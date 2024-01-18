class Game::Time < ApplicationRecord
  belongs_to :game

  def progress
    self.current += 1
  end
end
