class AddUserGameNumberToGames < ActiveRecord::Migration[6.1]
  def change
    add_column :games, :user_game_number, :integer
  end
end
