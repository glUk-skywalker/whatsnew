class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  def current_user
    @current_user ||= create_user_from_session
  end

  def create_user_from_session
    User.create(session[:user_id], session[:user_name], session[:user_email])
  end

end
