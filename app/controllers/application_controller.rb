class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def sign_in(user)
    token = SecureRandom.urlsafe_base64
    session[:session_token] = token
    user.update_attribute(:session_token, token)
  end 
end
