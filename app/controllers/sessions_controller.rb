class SessionsController < ApplicationController
  layout 'unauthenticated', only: [:new]

  def create
    user = create_user_from_omniauth_hash(request.env['omniauth.auth'])
    set_current_user(user)
    redirect_to root_path
  end

  def failure
    flash[:auth_error] = 'Login failure'
    redirect_to sign_in_path
  end

  def destroy
    unset_current_user if current_user
    redirect_to sign_in_path
  end

  private

  def create_user_from_omniauth_hash(oh)
    User.create(oh.uid, oh.user_info.name, oh.user_info.mail)
  end

  def set_current_user!(user)
    session[:user_id] = user.uid
    session[:user_name] = user.name
    session[:user_email] = user.email
    nil
  end

  def unset_current_user
    session[:user_id] = nil
    session[:user_name] = nil
    session[:user_email] = nil

    nil
  end
end
