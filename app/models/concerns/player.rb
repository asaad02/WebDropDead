# app/models/player.rb
class Player
    attr_accessor :name, :dice_count, :score
  
    def initialize(name, dice_count)
      @name = name
      @dice_count = dice_count
      @score = 0
    end
  
    def take_turn(dice)
      roll_values = dice.roll(@dice_count)
      if RollChecker.valid_roll?(roll_values)
        @score += roll_values.sum
        "#{@name} rolled #{roll_values} for a score of #{@score}."
      else
        # Handle invalid roll, e.g., losing dice
      end
    end
end
  