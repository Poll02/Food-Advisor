class MenusController < ApplicationController
  layout 'with_sidebar'
  before_action :set_menu, only: [:show, :edit, :update]

  def show
    # Il contenuto del menu è già impostato da set_menu
  end

  def edit
    # Il contenuto del menu è già impostato da set_menu
  end

  def update
    if @menu.update(menu_params)
      redirect_to menu_path(@menu), notice: 'Menu aggiornato con successo.'
    else
      render :edit
    end
  end

  private

  def set_menu
    @menu = Menu.first_or_initialize
  end

  def menu_params
    params.require(:menu).permit(:name, dishes_attributes: [:id, :name, :price, :ingredients, :_destroy])
  end
end
