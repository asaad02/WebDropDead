# app/services/auto_drop_dead.rb
module AutoDropDead
  class AutoDropDead
    attr_reader :players, :dice, :turn_tracker, :game_ui

    def initialize(sides, dice_count, player_count)
      @dice = Dice.new(sides)
      @players = Array.new(player_count) { |i| Player.new("Player #{i + 1}", dice_count) }
      @turn_tracker = TurnTracker.new(@players)
      @game_ui = GameUI.new
      @eliminated_players = [] # Initialize an array to track eliminated players
    end

    def play_game
      game_ui.add_message("Game has started with #{players.count} players and dice having #{dice.sides} sides.")
      play_rounds
      winner = determine_winner
      game_ui.add_message(winner ? "The winner is #{winner.name} with a score of #{winner.score}!" : "No winner determined.")
      game_ui.messages
    end

    private

    def play_rounds
      until players.empty?
        current_player = turn_tracker.current_player
        roll_values = dice.roll(current_player.dice_count)
        RollChecker.evaluate_roll(current_player, roll_values, game_ui)
        
        if current_player.out_of_dice?
          eliminate_player(current_player) # Eliminate the player
        else
          turn_tracker.advance_turn
        end
      end
    end

    def determine_winner
      # Determine the winner from all players, including eliminated ones
      (players + @eliminated_players).max_by(&:score)
    end

    # Track eliminated players
    def eliminate_player(player)
      game_ui.add_message("#{player.name} has been eliminated with a score of #{player.score}.")
      @eliminated_players << player
      players.reject! { |p| p == player }
    end
  end

  class GameUI
    attr_reader :messages

    def initialize
      @messages = []
    end

    def add_message(message)
      @messages << message
    end
  end

  module RollChecker
    def self.evaluate_roll(player, roll_values, game_ui)
      dice_lost = roll_values.count { |value| [2, 5].include?(value) }
      player.lose_dice(dice_lost)
      game_ui.add_message("#{player.name} rolls #{roll_values.inspect} and loses #{dice_lost} dice.")
      if player.out_of_dice?
        game_ui.add_message("#{player.name} has been eliminated.")
      else
        score = roll_values.sum
        player.add_score(score)
        game_ui.add_message("#{player.name}'s score is now #{player.score}.")
      end
    end
  end

  class Dice
    MIN_SIDES = 6

    attr_reader :sides

    def initialize(sides)
      @sides = [sides, MIN_SIDES].max
    end

    def roll(number_of_dice)
      Array.new(number_of_dice) { rand(1..@sides) }
    end
  end

  class TurnTracker
    attr_reader :players

    def initialize(players)
      @players = players.cycle
    end

    def current_player
      @players.next
    end

    def advance_turn
      current_player # The cycle method makes the player array act like a circular buffer.
    end
  end
end

# Assuming Player class is defined elsewhere in your application.
class Player
  attr_accessor :name, :dice_count, :score

  def initialize(name, dice_count)
    @name = name
    @dice_count = dice_count
    @score = 0
  end

  def out_of_dice?
    @dice_count <= 0
  end

  def lose_dice(count)
    @dice_count -= count
  end

  def add_score(points)
    @score += points
  end
end
