class CreateGameTimes < ActiveRecord::Migration[7.1]
  def change
    create_table :game_times do |t|
      t.references :game
      t.bigint :current

      t.timestamps
    end
  end
end
