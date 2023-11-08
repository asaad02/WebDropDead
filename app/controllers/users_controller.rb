# app/controllers/users_controller.rb
class UsersController < ApplicationController
  before_action :authenticate_user, only: [:show]
  before_action :set_user, only: [:show, :create]

  def new
    @user = User.new
  end

  def create
    if @user.save
      session[:user_id] = @user.id # This will sign in the user upon account creation.
      redirect_to user_page_path(@user), notice: 'Account created successfully.'
    else
      render template: 'sessions/new'
    end
  end

  def show
  end

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def authenticate_user
    redirect_to new_session_path, alert: 'You must be signed in to access that page.' unless current_user
  end

  def set_user
    @user = current_user || User.new(user_params)
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
end
