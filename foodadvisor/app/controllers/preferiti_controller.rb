class PreferitiController < ApplicationController
  layout 'with_sidebar'

  before_action :require_logged_in, except: [:public_show]
  before_action :require_customer, except: [:public_show]
  def show
    @ristoranti_ids = FavRistoranti.where(user_id: current_user.cliente.user.id).pluck(:ristoratore_id)
    @ristoranti_preferiti = Ristoratore.where(id: @ristoranti_ids)
    @recipe = FavRecipe.where(user_id: current_user.cliente.user.id).pluck(:recipe_id)
    @ricette_preferite = Recipe.where(id: @recipe)

  end


  private

  def require_logged_in
    unless logged_in?
      redirect_to login_path
    end
  end

  def require_customer
    unless session[:role] == 'User'
      redirect_to root_path
    end
  end
end

