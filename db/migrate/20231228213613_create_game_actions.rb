class CreateGameActions < ActiveRecord::Migration[7.1]
  def change
    create_table :game_actions do |t|
      t.references :game
      t.string :action_type
      t.jsonb :data

      t.timestamps
    end
  end
end
