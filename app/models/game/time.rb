class Game::Time < ApplicationRecord
  def progress
    self.current += 1
  end
end
