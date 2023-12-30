class GamesController < ApplicationController
  before_action :set_player_identity, :set_game

  def play
    @game.save if @game.join(@player_identity)

    # TASK - add player status view
    @player = Game::Player.find_by(identity: @player_identity)
  end

  def move
    Game::Action.create(
      game_id: @game.id,
      action_type: 'move',
      data: { player_identity: @player_identity, direction: params[:direction] }
    )

    render json: {}
  end

  protected

  def set_player_identity
    @player_identity = cookies.permanent[:player_identity] || SecureRandom.uuid
    cookies.permanent[:player_identity] = @player_identity
  end

  def set_game
    # TASK - add indexes for all used queries
    @game = Game.where(active: true).first
    return if @game

    raise StandardError, 'no_game'
  end
end
