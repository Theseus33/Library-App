class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  helper_method :current_user
  
  private

  def sign_in(user)
    session[:session_token] = SecureRandom.urlsafe_base64
    user.update!(session_token: session[:session_token])
  end 

  def sign_out
    return unless current_user
    current_user.update_attribute(:session_token, nil)
    session.delete(:token)
  end

  def current_user 
    @current_user ||= find_current_user
  end

  def find_current_user
    session_token = session[:session_token]
    session_token && User.find_by(session_token: session_token)
  end

  def ensure_signed_in
    return if current_user
    flash[:error] = 'Sorry, you must be signed in first!'
    redirect_to users_path
  end

  def ensure_signed_out
    return unless current_user
    flash[:error] = 'You are already signed in!'
    redirect_to users_path
  end

end
