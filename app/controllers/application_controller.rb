class ApplicationController < ActionController::Base
    helper_method :current_user # Makes current_user method available in views

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
