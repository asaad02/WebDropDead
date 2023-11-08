class CreateGames < ActiveRecord::Migration[6.1]
  def change
    create_table :games do |t|
      t.integer :player_count
      t.integer :dice_count
      t.integer :sides

      t.timestamps
    end
  end
end
