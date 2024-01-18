class StartGameService
  def self.call
    return false if Game.running.any?

    # this is something I would put in a repository, but I don't want to leave Rails too much
    world = Game::World.new
    world.rotations = Array.new(Game::World::LEVELS.count) { 0 }

    game = Game.new(
      world:,
      last_action_id: 0,
      train_position: 0
    )
    game.save!

    time = Game::Time.new(
      game:,
      current: 0
    )
    time.save!
  end
end
