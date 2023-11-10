# app/helpers/application_helper.rb
module ApplicationHelper
    def determine_redirect_path(user)
      user_page_path(user) 
    end
  end
  