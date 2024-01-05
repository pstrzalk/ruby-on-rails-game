class GamesController < ApplicationController
  before_action :set_player_identity, :set_game

  def start
    StartGameService.call unless @game.running?

    redirect_to :play
  end

  def play
    join_player if @game.running

    # TASK - add player status view
    @player = @game.players.find_by(identity: @player_identity)
  end

  def move
    if @game.running?
      Game::Action.create(
        game_id: @game.id,
        action_type: 'move',
        data: { player_identity: @player_identity, direction: params[:direction] }
      )
    end

    render json: {}
  end

  protected

  def join_player
    @game.save if @game.join(@player_identity)
  end

  def next_player_identity
    SecureRandom.uuid
  end

  def set_player_identity
    @player_identity = cookies.permanent[:player_identity] || next_player_identity
    cookies.permanent[:player_identity] = @player_identity
  end

  def set_game
    # TASK - add indexes for all used queries, discuss if one on 'running' is needed?
    # find a running game
    @game = Game.find_by(running: true)

    # find the last finished game
    @game ||= Game.where(running: false).last
    return if @game

    raise StandardError, 'no_game'
  end
end
