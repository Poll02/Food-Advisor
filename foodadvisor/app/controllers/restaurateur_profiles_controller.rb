class RestaurateurProfilesController < ApplicationController
  layout 'with_sidebar'
  
  before_action :require_logged_in
  before_action :require_restaurant_owner

  def show
    @restaurant_owner = current_user
    @promotions = Promotion.where(ristoratore_id: current_user.id)

    # Logica per la pagina del profilo del ristoratore
  end

  private

  def require_logged_in
    unless logged_in?
      redirect_to login_path
    end
  end

  def require_restaurant_owner
    unless current_user.role == 'restaurant_owner'
      redirect_to root_path
    end
  end

end
