# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email])
    if user.nil?
      flash.now[:alert] = 'User does not exist. Please sign up.'
      render :new
    elsif user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      redirect_to user_page_path(user)
    else
      flash.now[:alert] = 'Password is incorrect.'
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to new_session_path, notice: 'Signed out successfully.'
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end

end
