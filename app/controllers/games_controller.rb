# frozen_string_literal: true

class GamesController < ApplicationController
  before_action :set_player_identity

  def index
    @games = Game.all.order(id: :desc)
  end

  def show
    @game = Game.find(params[:id])

    @player = @game.players.find_by(identity: @player_identity)
  end

  def create
    Game::Start.call if Game.running.size < 5

    redirect_to games_path
  end

  def join
    @game = Game.find_by(id: params[:id])

    unless @game
      redirect_to games_path, error: 'No such game'
      return
    end

    unless @game.running?
      redirect_to games_path, notice: 'Game already finished'
      return
    end

    @game.join(@player_identity)
    @game.save!

    redirect_to @game
  end

  def move
    game_exists = Game.running.exists?(id: params[:id])
    unless game_exists
      redirect_to games_path, error: 'No such game'
      return
    end

    Game::Action.create(
      game_id: params[:id],
      action_type: 'move',
      data: { player_identity: @player_identity, direction: params[:direction] }
    )

    render json: {}
  end

  protected

  def set_player_identity
    @player_identity = cookies.permanent[:player_identity]
    @player_identity ||= SecureRandom.uuid
    cookies.permanent[:player_identity] = @player_identity
  end
end
