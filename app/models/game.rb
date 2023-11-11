# app/models/game.rb
class Game < ApplicationRecord
  belongs_to :user, optional: true
  serialize :results, Array
  validates :player_count, :dice_count, :sides , presence: true 
  before_create :assign_game_number

  def play_game!
    auto_drop_dead = AutoDropDead::AutoDropDead.new(sides, dice_count, player_count)
    self.results = auto_drop_dead.play_game
    results
  end


  def assign_game_number
    self.user_game_number = user.games.count + 1
  end

end
