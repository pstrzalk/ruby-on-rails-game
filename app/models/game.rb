class Game < ApplicationRecord
  PlayerNotInGame = Class.new(StandardError)
  InvalidDirection = Class.new(StandardError)

  # Where should time belong? it is used only in the World but it also affects players
  # I think it belongs to the game, as it may interfere with other elements in the future
  belongs_to :time, class_name: 'Game::Time', dependent: :destroy
  accepts_nested_attributes_for :time

  has_many :players, class_name: 'Game::Player', dependent: :destroy
  accepts_nested_attributes_for :players

  belongs_to :world, class_name: 'Game::World', dependent: :destroy
  accepts_nested_attributes_for :world

  broadcasts_to ->(game) { "game_#{game.id}" }

  MOVE_LEFT = 'l'.freeze
  MOVE_RIGHT = 'r'.freeze
  MOVE_FORWARD = 'f'.freeze
  MOVE_BACK = 'b'.freeze
  MOVE_DIRECTIONS = Set.new([MOVE_LEFT, MOVE_RIGHT, MOVE_FORWARD, MOVE_BACK]).freeze

  TRAIN_SPEED = 1000

  # hammer?

  # Improper design
  # Game should define player_identity (or even Player might?) and return it.
  # But it makes it harder to control idempotency when used in the controller
  def join(player_identity)
    return false if players.any? { _1.identity == player_identity }

    players.build(
      identity: player_identity,
      position_vertical: World::INITIAL_LEVEL,
      position_horizontal: rand(World::INITIAL_POSITION_RANGE)
    )

    true
  end

  def progress(actions: [])
    return false unless running

    self.last_action_id = actions.last.id if actions.any?

    progress_world
    progress_players(actions)
    progress_train
    progress_time

    changed? || world.changed? || players.any?(&:changed?)
  end

  protected

  def game_over(won_by: nil)
    self.running = false
    self.winner = won_by
  end

  def progress_train
    return unless (time.current % TRAIN_SPEED).zero?

    if train_position == Game::World::WIDTH
      game_over
    else
      winner = players.find do |player|
        player.position_vertical == World::RAILWAY_LEVEL && player.position_horizontal == train_position
      end

      if winner
        game_over(won_by: winner.id)
      else
        self.train_position += 1
      end
    end
  end

  def progress_time
    time.progress
    time.save
  end

  def progress_world
    world.progress(time.current)

    players.each do |player|
      next unless player.alive?

      player.kill unless world.safe_at?(player.position_vertical, player.position_horizontal)
    end
  end

  def progress_players(actions)
    moves = moves_from_actions(actions)

    players.select(&:alive?).each do |player|
      while player.alive? && moves[player.identity].present?
        move = moves[player.identity].pop

        if move == MOVE_LEFT && player.position_horizontal.positive?
          player.move_left
        elsif move == MOVE_RIGHT && player.position_horizontal < Game::World::WIDTH - 1
          player.move_right
        elsif move == MOVE_FORWARD && player.position_vertical < Game::World::RAILWAY_LEVEL
          player.move_forward
        elsif move == MOVE_BACK && player.position_vertical.positive?
          player.move_back
        end

        player.kill unless world.safe_at?(player.position_vertical, player.position_horizontal)
      end
    end
  end

  def moves_from_actions(actions)
    return {} unless actions.any?

    actions.each_with_object({}) do |action, memo|
      player_identity = action.data['player_identity']
      next memo unless player_identity.present?

      memo[player_identity] ||= []
      memo[player_identity] << action.data['direction']

      memo
    end
  end
end
