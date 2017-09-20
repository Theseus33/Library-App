class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  helper_method :current_user
  
  private
#private methods that define user token creation and deletion 
#defines methods for token based user sessions
  def sign_in(user)
    session[:session_token] = SecureRandom.urlsafe_base64
    user.update!(session_token: session[:session_token])
  end 
#destroys token to sign user out
  def sign_out
    return unless current_user
    current_user.update_attribute(:session_token, nil)
    session.delete(:token)
  end
#defines current user
  def current_user 
    @current_user ||= find_current_user
  end
#finds user based on user session token
  def find_current_user
    session_token = session[:session_token]
    session_token && User.find_by(session_token: session_token)
  end
#if user is signed in already it returns an error on login/user creation screens 
  def ensure_signed_in
    return if current_user
    flash[:error] = 'Sorry, you must be signed in first!'
    redirect_to users_path
  end
#returns error if user is trying to do something that requires sign in
  def ensure_signed_out
    return unless current_user
    flash[:error] = 'You are already signed out!'
    redirect_to users_path
  end

end
