# app/controllers/games_controller.rb
class GamesController < ApplicationController
  before_action :set_game, only: [:show, :replay]

  def new
    @game = Game.new
  end

  def create
    #@game = Game.new(game_params)
    @game = current_user.games.new(game_params)
  
    if @game.save
      @results = @game.play_game!
      if @game.update(results: @results)
        Rails.logger.debug "Game results saved successfully."
      else
        Rails.logger.debug "Failed to save game results: #{@game.errors.full_messages}"
      end
      redirect_to @game, notice: 'Game has started!'
    else
      render :new
    end
  end

  # Modify the show action to handle displaying a specific game from the history page
  def show
    if params[:game_id]
      @game = Game.find_by_id(params[:game_id])
      unless @game
        redirect_to history_games_path, alert: "Game not found with ID: #{params[:game_id]}"
      end
    else
      @game = Game.find(params[:id])
    end
    replay if params[:replay]

  end
  

  def history
    if params[:game_id].present?
      @selected_game = current_user.games.find_by(id: params[:game_id])
      unless @selected_game
        flash[:alert] = "Game not found with ID: #{params[:game_id]}"
        redirect_to history_games_path
      end
    else
      @games = current_user.games.order(created_at: :desc)
    end
  end

  def replay
    # Use attributes from the existing game to create a new game for replay
    replayed_game_attrs = @game.attributes.except("id", "created_at", "updated_at", "results")
    @new_game = current_user.games.new(replayed_game_attrs)
    
    if @new_game.save
      @results = @new_game.play_game!
      if @new_game.update(results: @results)
        Rails.logger.debug "Game results saved successfully."
        redirect_to game_path(@new_game), notice: 'The game has been replayed!'
      else
        Rails.logger.debug "Failed to save game results: #{new_game.errors.full_messages}"
        redirect_to game_path(@game), alert: 'Failed to replay the game.'
      end
    else
      render :new, alert: @new_game.errors.full_messages.to_sentence
    end
  end

  def set_game
    @game = Game.find(params[:id])
  end

  def game_params
    params.require(:game).permit(:player_count, :dice_count, :sides)
  end
  

end
