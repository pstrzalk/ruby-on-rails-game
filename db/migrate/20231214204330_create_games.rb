class CreateGames < ActiveRecord::Migration[7.1]
  def change
    create_table :games do |t|
      t.references :time
      t.references :world

      t.bigint :last_action_id

      t.boolean :active, default: false

      t.timestamps
    end
  end
end
