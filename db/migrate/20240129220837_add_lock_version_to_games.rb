class AddLockVersionToGames < ActiveRecord::Migration[7.1]
  def change
    add_column :games, :lock_version, :integer, default: 0
  end
end
