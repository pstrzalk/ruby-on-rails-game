class ProgressGameService
  def self.call
    game = Game.where(running: true).last
    return false unless game

    next_action_id = game.last_action_id + 1
    pending_actions = Game::Action.where(game_id: game.id, id: next_action_id..).order(id: :asc)

    changed = game.progress(actions: pending_actions)
    game.save if changed
  end
end
