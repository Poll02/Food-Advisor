class UserProfileController < ApplicationController
  layout :determine_layout

  before_action :require_logged_in
  before_action :require_customer

  def show
    @user = current_user
    # Logica per la pagina del profilo del cliente
  end

  def public_show
    @user = current_user
  end

  def determine_layout
    action_name == 'public_show' ? 'application' : 'with_sidebar'
  end


  private

  def require_logged_in
    unless logged_in?
      redirect_to login_path
    end
  end

  def require_customer
    unless current_user.role == 'user'
      redirect_to root_path
    end
  end
end
