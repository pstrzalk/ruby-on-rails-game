require 'test_helper'

class GameTest < ActiveSupport::TestCase
  def setup
    @game = Game.construct
  end

  test "should not allow duplicate player_identity in join" do
    existing_player_identity = SecureRandom.uuid
    @game.players.build(identity: existing_player_identity)

    assert_not @game.join(existing_player_identity)
  end

  test "should allow unique player_identity in join" do
    player_identity = SecureRandom.uuid

    assert @game.join(player_identity)
    assert_equal 1, @game.players.size
    assert_equal player_identity, @game.players.first.identity
  end

  test "running? should return true for a running game" do
    @game.finished_at = nil
    assert @game.running?
  end

  test "running? should return false for a finished game" do
    @game.finished_at = Time.current
    assert_not @game.running?
  end

  test "winner should return the winning player" do
    winning_player = Game::Player.new(winner: true)
    @game.players << winning_player
    @game.finished_at = Time.current

    assert_equal winning_player, @game.winner
  end

  test "winner should return nil for a running game" do
    @game.finished_at = nil
    assert_nil @game.winner
  end

  test "progress should update game state correctly" do
    player_identity = SecureRandom.uuid
    player = @game.players.build(identity: player_identity, position_vertical: 0, position_horizontal: 0, alive: true)

    assert @game.running?
    assert_nil @game.finished_at
    assert_nil @game.winner

    timestamp = 1
    actions = [
      Game::Action.new(id: 1, data: { 'player_identity' => player_identity, 'direction' => Game::MOVE_FORWARD })
    ]
    @game.progress(timestamp:, actions:)

    assert @game.changed?
    assert_equal timestamp, @game.last_action_id
    assert_equal 0, player.position_horizontal
    assert_equal 1, player.position_vertical

    assert @game.world.changed?
    assert_nil @game.finished_at
    assert_nil @game.winner
  end

  test "progress and move player right" do
    player_identity = SecureRandom.uuid
    player = @game.players.build(identity: player_identity, position_vertical: 0, position_horizontal: 4, alive: true)

    actions = [
      Game::Action.new(id: 1, data: { 'player_identity' => player_identity, 'direction' => Game::MOVE_RIGHT })
    ]
    @game.progress(timestamp: 1, actions:)

    assert_equal 0, player.position_vertical
    assert_equal 5, player.position_horizontal
  end

  test "progress and move player left" do
    player_identity = SecureRandom.uuid
    player = @game.players.build(identity: player_identity, position_vertical: 0, position_horizontal: 4, alive: true)

    actions = [
      Game::Action.new(id: 1, data: { 'player_identity' => player_identity, 'direction' => Game::MOVE_LEFT })
    ]
    @game.progress(timestamp: 1, actions:)

    assert_equal 0, player.position_vertical
    assert_equal 3, player.position_horizontal
  end

  test "progress and move player back" do
    player_identity = SecureRandom.uuid
    player = @game.players.build(identity: player_identity, position_vertical: 1, position_horizontal: 0, alive: true)

    actions = [
      Game::Action.new(id: 1, data: { 'player_identity' => player_identity, 'direction' => Game::MOVE_BACK })
    ]
    @game.progress(timestamp: 1, actions:)

    assert_equal 0, player.position_vertical
    assert_equal 0, player.position_horizontal
  end

  test 'progresses train' do
    timestamp = Game::TRAIN_MOVES_EVERY - 1
    @game.train_position = 4

    @game.progress(timestamp:)
    assert_equal 4, @game.train_position

    timestamp += 1
    @game.progress(timestamp:)
    assert_equal 5, @game.train_position
    assert_nil @game.finished_at
  end

  test "progress and make train finish the game by going off screen" do
    @game.train_position = 29
    timestamp = Game::TRAIN_MOVES_EVERY

    @game.progress(timestamp:)
    assert_equal 30, @game.train_position
    assert_equal timestamp, @game.finished_at
  end

  test "progress and make player catch a train" do
    player_identity = SecureRandom.uuid
    player = @game.players.build(
      identity: player_identity, position_vertical: Game::World::RAILWAY_LEVEL, position_horizontal: 21, alive: true
    )

    @game.train_position = 20
    timestamp = Game::TRAIN_MOVES_EVERY

    @game.progress(timestamp:)
    assert_equal 21, @game.train_position
    assert_equal timestamp, @game.finished_at
    assert_equal player, @game.winner
  end
end