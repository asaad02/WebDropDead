# app/models/game.rb
class Game < ApplicationRecord
  belongs_to :user, optional: true
  serialize :results, Array
  validates :player_count, :dice_count, :sides , presence: true 

  after_initialize :set_default_values

  def set_default_values
    self.player_count ||= 2
    self.dice_count ||= 5
    self.sides ||= 6
  end

  def play_game!
    auto_drop_dead = AutoDropDead::AutoDropDead.new(sides, dice_count, player_count)
    #auto_drop_dead = AutoDropDead::AutoDropDead.new(6,6,6)
    self.results = auto_drop_dead.play_game
    # Return the results without immediately saving, to allow controller to handle it
    results
    
  end

end
