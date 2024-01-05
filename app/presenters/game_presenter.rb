class GamePresenter
  def initialize(game:)
    self.game = game
  end

  def rows
    @rows ||= Game::World::LEVELS.reverse.each_with_index.map do |row, index|
      row.pattern.split('').rotate(game.world.rotations[index])
    end
  end

  def train_position
    game.train_position
  end

  def players_positions
    return @players_positions if @players_positions

    @players_positions = {}
    game.players.each do |player|
      next unless player.alive?

      @players_positions[Game::World::RAILWAY_LEVEL - player.position_vertical] ||= {}
      @players_positions[Game::World::RAILWAY_LEVEL - player.position_vertical][player.position_horizontal] ||= []
      @players_positions[Game::World::RAILWAY_LEVEL - player.position_vertical][player.position_horizontal] << player
    end

    @players_positions
  end

  # def call(for_player_identity: nil)
  #   players_positions.each do |position_vertical, positions_horizontal|
  #     positions_horizontal.each do |position_horizontal, players|
  #       levels_as_rows[position_vertical][position_horizontal] = players.size > 1 ? 'Z' : 'P'
  #     end
  #   end

  #   levels_as_rows.map(&:join).reverse.join("\n")
  # end

  private

  attr_accessor :game
end
