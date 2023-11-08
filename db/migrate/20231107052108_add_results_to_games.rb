class AddResultsToGames < ActiveRecord::Migration[6.1]
  def change
    add_column :games, :results, :text
  end
end