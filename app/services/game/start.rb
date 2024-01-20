class Game::Start
  def self.call
    game = Game.construct
    game.save!

    time = Game::Time.new(game:, current: 0)
    time.save!

    game
  end
end
