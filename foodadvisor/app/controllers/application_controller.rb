class ApplicationController < ActionController::Base
    include SessionsHelper
    before_action :set_user_settings

  private

  def set_user_settings
    @user_settings = current_user&.setting || Setting.default_settings
  end

  def current_user
    if (user_id = session[:user_id])
      @current_user ||= Utente.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = Utente.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in(user, user_role(user))  # Login come utente normale
        @current_user = user
      end
    end
  end
  
  def logged_in?
    !current_user.nil?
  end
end
