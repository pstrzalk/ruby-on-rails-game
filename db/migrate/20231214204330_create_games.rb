class CreateGames < ActiveRecord::Migration[7.1]
  def change
    create_table :games do |t|
      t.references :world

      t.integer :train_position
      t.bigint :last_action_id

      t.bigint :finished_at

      t.integer :lock_version # optimistic locking
      t.timestamps
    end
  end
end
