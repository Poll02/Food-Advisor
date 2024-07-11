class ApplicationController < ActionController::Base
    include SessionsHelper
    before_action :set_user_settings

  private

  def set_user_settings
    @user_settings = current_user&.setting || Setting.default_settings
  end

  def current_user
    if session[:user_id].present?
      @current_user = Utente.find_by(id: session[:user_id])
    else
      @current_user = nil
    end
  end  
  
end
