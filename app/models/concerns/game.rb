# app/models/game.rb

require_dependency 'app/services/dice'
class Game < ApplicationRecord
    serialize :state, Array
    has_many :players
  
    validates :player_count, :dice_count, :sides, presence: true
  
    after_create :play_game!
  
    def play_game!
      # Initialize game state
      self.state = []
      dice = Dice.new(self.sides)
      players = Array.new(self.player_count) { |i| Player.new("Player #{i + 1}", self.dice_count) }
      turn_tracker = TurnTracker.new(players)
      
      # Game loop
      until turn_tracker.no_players_left?
        current_player = turn_tracker.current_player
        turn_result = current_player.take_turn(dice)
        self.state << turn_result
        turn_tracker.next_turn!
      end
  
      # Save the game outcome
      save!
    end
  end
  