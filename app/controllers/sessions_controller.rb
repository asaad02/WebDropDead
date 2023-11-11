# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  def new
    @user = User.new 
  end


  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      redirect_to user_page_path(user), notice: 'Signed in successfully.'
    elsif user.nil?
      redirect_to new_session_path, notice: 'User does not exist. Please sign up.'
    else
      redirect_to new_session_path, notice: 'Password is incorrect.'
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
