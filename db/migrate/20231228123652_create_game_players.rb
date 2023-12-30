class CreateGamePlayers < ActiveRecord::Migration[7.1]
  def change
    create_table :game_players do |t|
      t.references :game

      t.uuid :identity

      t.boolean :alive, default: true
      t.integer :position_horizontal, default: 0
      t.integer :position_vertical, default: 0

      t.timestamps
    end
  end
end
