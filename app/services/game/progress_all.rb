class Game::ProgressAll
  def self.call
    Game.running.each do |game|
      Game::Progress.call(game)
    end
  end
end
