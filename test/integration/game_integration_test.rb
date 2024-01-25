require 'test_helper'

class GameIntegrationTest < ActionDispatch::IntegrationTest
  test 'lists running games' do
    game = Game.construct
    game.save

    get '/games'

    assert_select 'td', game.id.to_s
    assert_select 'td', 'Ongoing'
    assert_select 'a', 'Play'
  end

  test 'lists finished games' do
    game = Game.construct
    game.finished_at = Time.current
    game.save

    get '/games'

    assert_select 'td', game.id.to_s
    assert_select 'td', 'Finished'
    assert_select 'a', 'Check result'
  end

  test 'shows join game link for visitor' do
    game = Game.construct
    game.finished_at = nil
    game.save!

    get "/games/#{game.id}"

    assert_select 'a', 'Join'
  end

  test 'shows no join game link for visitor' do
    game = Game.construct
    game.finished_at = Time.current
    game.save!

    get "/games/#{game.id}"

    assert_select 'a', text: 'Join', count: 0
  end

  test 'creates a new game' do
    assert_nil Game.first

    post '/games/'

    assert_equal 1, Game.count
  end

  test 'creates no new game if there are already 5' do
    Game.construct.save
    Game.construct.save
    Game.construct.save
    Game.construct.save
    Game.construct.save

    assert_equal 5, Game.count

    post '/games/'

    assert_equal 5, Game.count
  end

  test 'joins a game' do
    game = Game.construct
    game.save

    assert_equal 0, game.players.size

    get "/games/#{game.id}/join"

    game.reload

    assert_equal 1, game.players.size
  end

  test 'does not join a finished game' do
    game = Game.construct
    game.finished_at = Time.current
    game.save

    get "/games/#{game.id}/join"

    assert_redirected_to games_path
  end

  test 'creates a game action' do
    identity = SecureRandom.uuid

    game = Game.construct
    game.players.build(identity:, position_vertical: 3, position_horizontal: 3, alive: true)
    game.save

    cookies[:player_identity] = identity

    put "/games/#{game.id}/move/f"

    action = Game::Action.find_by(game_id: game.id)

    assert_equal identity, action.data['player_identity']
    assert_equal 'f', action.data['direction']
  end

  test 'redirects if game does not exist' do
    game = Game.construct
    game.finished_at = Time.current
    game.save

    put "/games/#{game.id}/move/f"

    assert_redirected_to games_path
  end
end
