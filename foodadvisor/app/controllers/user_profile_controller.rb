class UserProfileController < ApplicationController
  layout 'with_sidebar'

  before_action :require_logged_in
  before_action :require_customer

  def show
    @user = current_user
    # Logica per la pagina del profilo del cliente
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
