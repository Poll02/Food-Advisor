class AdminProfileController < ApplicationController
  before_action :require_logged_in
  before_action :require_admin

  def show
    @admin = current_user
    # Logica per la pagina del profilo admin
  end

  private

  def require_logged_in
    unless logged_in?
      redirect_to login_path
    end
  end

  def require_admin
    unless current_user.role == 'admin'
      redirect_to root_path
    end
  end
end
