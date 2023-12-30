class CreateGameWorlds < ActiveRecord::Migration[7.1]
  def change
    create_table :game_worlds do |t|
      t.integer :rotations, array: true

      t.timestamps
    end
  end
end
