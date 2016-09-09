class AuthenticatedUserController < ApplicationController
  
  before_action :authenticated?

  def authenticated?
    unless current_user
      redirect_to sign_in_path
    end
  end

end
