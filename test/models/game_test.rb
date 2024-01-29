# frozen_string_literal: true

require 'test_helper'

class GameTest < ActiveSupport::TestCase
  test 'should not allow duplicate player_identity in join' do
    game = Game.construct
    existing_player_identity = SecureRandom.uuid
    game.players.build(identity: existing_player_identity)

    assert_not game.join(existing_player_identity)
  end

  test 'should allow unique player_identity in join' do
    game = Game.construct
    player_identity = SecureRandom.uuid

    assert game.join(player_identity)
    assert_equal 1, game.players.size
    assert_equal player_identity, game.players.first.identity
  end

  test 'running? should return true for a running game' do
    game = Game.construct
    game.finished_at = nil

    assert_predicate game, :running?
  end

  test 'running? should return false for a finished game' do
    game = Game.construct
    game.finished_at = Time.current

    assert_not game.running?
  end

  test 'winner should return the winning player' do
    game = Game.construct
    winning_player = Game::Player.new(winner: true)
    game.players << winning_player
    game.finished_at = Time.current

    assert_equal winning_player, game.winner
  end

  test 'winner should return nil for a running game' do
    game = Game.construct
    game.finished_at = nil

    assert_nil game.winner
  end

  test 'progress should change state' do
    game = Game.construct
    player_identity = SecureRandom.uuid
    game.players.build(identity: player_identity, position_vertical: 0, position_horizontal: 0, alive: true)

    timestamp = 1
    actions = [
      Game::Action.new(id: 7, data: { 'player_identity' => player_identity, 'direction' => Game::MOVE_FORWARD })
    ]
    game.progress(timestamp:, actions:)

    assert_predicate game, :changed?
    assert_predicate game.world, :changed?
  end

  test 'progress and update last_action_id' do
    game = Game.construct
    player_identity = SecureRandom.uuid

    actions = [
      Game::Action.new(id: 7, data: { 'player_identity' => player_identity, 'direction' => Game::MOVE_FORWARD })
    ]
    game.progress(timestamp: 1, actions:)

    assert_equal 7, game.last_action_id
  end

  test 'progress and move player forward' do
    game = Game.construct
    player_identity = SecureRandom.uuid
    player = game.players.build(identity: player_identity, position_vertical: 0, position_horizontal: 0, alive: true)

    actions = [
      Game::Action.new(id: 1, data: { 'player_identity' => player_identity, 'direction' => Game::MOVE_FORWARD })
    ]
    game.progress(timestamp: 1, actions:)

    assert_equal 1, player.position_vertical
    assert_equal 0, player.position_horizontal
  end

  test 'progress and move player right' do
    game = Game.construct
    player_identity = SecureRandom.uuid
    player = game.players.build(identity: player_identity, position_vertical: 0, position_horizontal: 4, alive: true)

    actions = [
      Game::Action.new(id: 1, data: { 'player_identity' => player_identity, 'direction' => Game::MOVE_RIGHT })
    ]
    game.progress(timestamp: 1, actions:)

    assert_equal 0, player.position_vertical
    assert_equal 5, player.position_horizontal
  end

  test 'progress and move player left' do
    game = Game.construct
    player_identity = SecureRandom.uuid
    player = game.players.build(identity: player_identity, position_vertical: 0, position_horizontal: 4, alive: true)

    actions = [
      Game::Action.new(id: 1, data: { 'player_identity' => player_identity, 'direction' => Game::MOVE_LEFT })
    ]
    game.progress(timestamp: 1, actions:)

    assert_equal 0, player.position_vertical
    assert_equal 3, player.position_horizontal
  end

  test 'progress and move player back' do
    game = Game.construct
    player_identity = SecureRandom.uuid
    player = game.players.build(identity: player_identity, position_vertical: 1, position_horizontal: 0, alive: true)

    actions = [
      Game::Action.new(id: 1, data: { 'player_identity' => player_identity, 'direction' => Game::MOVE_BACK })
    ]
    game.progress(timestamp: 1, actions:)

    assert_equal 0, player.position_vertical
    assert_equal 0, player.position_horizontal
  end

  test 'progresses train' do
    game = Game.construct
    timestamp = Game::TRAIN_MOVES_EVERY - 1
    game.train_position = 4

    game.progress(timestamp:)

    assert_equal 4, game.train_position

    timestamp += 1
    game.progress(timestamp:)

    assert_equal 5, game.train_position
    assert_nil game.finished_at
  end

  test 'progress and make train finish the game by going off screen' do
    game = Game.construct
    game.train_position = 28
    timestamp = Game::TRAIN_MOVES_EVERY

    game.progress(timestamp:)

    assert_equal 29, game.train_position
    assert_equal timestamp, game.finished_at
  end

  test 'progress and make player catch a train' do
    game = Game.construct
    player_identity = SecureRandom.uuid
    player = game.players.build(
      identity: player_identity, position_vertical: Game::World::RAILWAY_LEVEL, position_horizontal: 21, alive: true
    )

    game.train_position = 20
    timestamp = Game::TRAIN_MOVES_EVERY

    game.progress(timestamp:)

    assert_equal 21, game.train_position
    assert_equal timestamp, game.finished_at
    assert_equal player, game.winner
  end

  test 'up to 4 alive players can join' do
    game = Game.construct
    joins = []
    joins << game.join(SecureRandom.uuid)
    joins << game.join(SecureRandom.uuid)
    joins << game.join(SecureRandom.uuid)
    joins << game.join(SecureRandom.uuid)
    game.players.last.kill
    joins << game.join(SecureRandom.uuid)
    joins << game.join(SecureRandom.uuid)

    assert_equal [true, true, true, true, true, false], joins
  end

  test 'pushes one player forward if they stack' do
    game = Game.construct
    game.players.build(identity: SecureRandom.uuid, position_vertical: 3, position_horizontal: 3, alive: true)
    game.players.build(identity: SecureRandom.uuid, position_vertical: 3, position_horizontal: 3, alive: true)

    game.progress(timestamp: 1)

    positions_vertical = [game.players.first.position_vertical, game.players.second.position_vertical]

    assert_equal [3, 4], positions_vertical.sort
  end
end
