# frozen_string_literal: true

class Game < ApplicationRecord
  has_many :players, class_name: 'Game::Player', dependent: :destroy
  accepts_nested_attributes_for :players

  belongs_to :world, class_name: 'Game::World', dependent: :destroy
  accepts_nested_attributes_for :world

  broadcasts_to ->(game) { "game_#{game.id}" } unless Rails.env.test?

  scope :running, -> { where(finished_at: nil) }

  MOVE_LEFT = 'l'
  MOVE_RIGHT = 'r'
  MOVE_FORWARD = 'f'
  MOVE_BACK = 'b'

  TRAIN_MOVES_EVERY = 30

  def self.construct
    instance = new
    instance.world = World.construct
    instance.last_action_id = 0
    instance.train_position = 0

    instance
  end

  def join(player_identity)
    return false if players.any? { _1.identity == player_identity }
    return false if players.size > 3

    players.build(
      identity: player_identity,
      position_vertical: World::INITIAL_LEVEL,
      position_horizontal: rand(World::INITIAL_POSITION_RANGE)
    )

    true
  end

  def running?
    finished_at.nil?
  end

  def winner
    return if running?

    players.find(&:winner?)
  end

  def progress(timestamp:, actions: [])
    return false unless running?

    self.last_action_id = actions.last.id if actions.any?

    progress_world(timestamp)
    progress_train(timestamp)
    progress_players(actions)

    changed? || world.changed? || players.any?(&:changed?)
  end

  protected

  def progress_world(timestamp)
    world.progress(timestamp)

    players.each do |player|
      next unless player.alive?

      player.kill unless world.safe_at?(player.position_vertical, player.position_horizontal)
    end
  end

  def progress_train(timestamp)
    if (timestamp % TRAIN_MOVES_EVERY).zero?
      self.train_position += 1

      if train_position == Game::World::WIDTH - 1
        self.finished_at = timestamp

        return
      end
    end

    winning_player = players.find do |player|
      player.position_vertical == World::RAILWAY_LEVEL && player.position_horizontal == train_position
    end

    return unless winning_player

    winning_player.winner = true
    self.finished_at = timestamp
  end

  def progress_players(actions) # rubocop:disable all
    moves = moves_from_actions(actions)

    players.select(&:alive?).each do |player|
      while player.alive? && moves[player.identity].present?
        move = moves[player.identity].pop

        if move == MOVE_LEFT && player.position_horizontal.positive?
          player.move_left
        elsif move == MOVE_RIGHT && player.position_horizontal < Game::World::WIDTH - 1
          player.move_right
        elsif (move == MOVE_FORWARD && player.position_vertical < Game::World::RAILWAY_LEVEL - 1) ||
              (move == MOVE_FORWARD && player.position_vertical == Game::World::RAILWAY_LEVEL - 1 &&
                player.position_horizontal == train_position)
          player.move_forward
        elsif move == MOVE_BACK && player.position_vertical.positive?
          player.move_back
        end

        player.kill unless world.safe_at?(player.position_vertical, player.position_horizontal)
      end
    end

    players_in_groups = players.select(&:alive?).each_with_object({}) do |player, memo|
      position = [player.position_horizontal, player.position_vertical]
      memo[position] ||= []
      memo[position] << player

      memo
    end

    stacked_players_actions = players_in_groups.values.filter_map do |players_in_group|
      next unless players_in_group.size > 1

      player_in_group = players_in_group.sample
      next if player_in_group.position_vertical == World::RAILWAY_LEVEL

      Action.new(data: { player_identity: player_in_group.identity, direction: MOVE_FORWARD })
    end

    progress_players(stacked_players_actions) if stacked_players_actions.any?
  end

  def moves_from_actions(actions)
    return {} unless actions.any?

    actions.each_with_object({}) do |action, memo|
      player_identity = action.data['player_identity']
      next memo if player_identity.blank?

      memo[player_identity] ||= []
      memo[player_identity] << action.data['direction']

      memo
    end
  end
end
