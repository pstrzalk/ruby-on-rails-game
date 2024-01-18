class ProgressGameService
  def self.call
    game = Game.running.last
    return false unless game

    next_action_id = game.last_action_id + 1
    pending_actions = Game::Action.where(game_id: game.id, id: next_action_id..).order(id: :asc)

    time = Game::Time.find_by(game:)
    time.progress
    time.save!

    changed = game.progress(timestamp: time.current, actions: pending_actions)
    game.save if changed
  end
end
