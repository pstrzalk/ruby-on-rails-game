class StartGameService
  def self.call
    return false if Game.where(active: true).any?

    # this is something I would put in a repository, but I don't want to leave Rails too much
    world = Game::World.new
    world.rotations = Array.new(Game::World::LEVELS.count) { 0 }

    time = Game::Time.new(current: 0)

    game = Game.new(active: true, world:, time:, last_action_id: 0)
    game.save
  end
end
