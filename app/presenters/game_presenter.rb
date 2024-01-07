class GamePresenter
  def initialize(game:)
    self.game = game
  end

  def rows
    @rows ||= Game::World::LEVELS.each_with_index.map do |row, index|
      row.pattern.split('').rotate(game.world.rotations[index])
    end.reverse
  end

  def train_position
    game.train_position
  end

  def players_positions
    return @players_positions if @players_positions

    @players_positions = {}
    game.players.each do |player|
      next unless player.alive?

      position_vertical = Game::World::RAILWAY_LEVEL - player.position_vertical

      @players_positions[position_vertical] ||= {}
      @players_positions[position_vertical][player.position_horizontal] ||= []
      @players_positions[position_vertical][player.position_horizontal] << player
    end

    @players_positions
  end

  private

  attr_accessor :game
end
