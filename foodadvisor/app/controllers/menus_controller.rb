class MenusController < ApplicationController
  layout 'with_sidebar'

  def show
    @categories = Category.includes(:dishes).all
  end

  def edit
    @categories = Category.includes(:dishes).all
    @new_category = Category.new
    @new_dish = Dish.new
  end

  def update
    ActiveRecord::Base.transaction do
      # Aggiorna le categorie esistenti
      params[:categories]&.each do |category_id, category_params|
        category = Category.find(category_id)
        category.update!(category_params.permit(:name))

        # Aggiorna i piatti esistenti
        category_params[:dishes]&.each do |dish_id, dish_params|
          dish = Dish.find(dish_id)
          dish.update!(dish_params.permit(:name, :price, :ingredients))
        end
      end

      # Aggiungi nuovi piatti
      if params[:new_dishes].present?
        params[:new_dishes].each do |category_id, dish_params|
          Dish.create!(
            category_id: category_id,
            name: dish_params[:name],
            price: dish_params[:price],
            ingredients: dish_params[:ingredients]
          )
        end
      end

      # Aggiungi nuova categoria
      if params[:new_category].present? && params[:new_category][:name].present?
        Category.create!(name: params[:new_category][:name], menu: @menu)
      end
    end

    redirect_to menus_path(@menu), notice: 'Menu aggiornato con successo.'
  rescue ActiveRecord::RecordInvalid => e
    flash.now[:alert] = "Errore durante l'aggiornamento: #{e.message}"
    render :edit
  end

  private

  def set_menu
    @menu = Menu.find(params[:id])
    @categories = @menu.categories.includes(:dishes)
  end

  def menu_params
    params.require(:menu).permit(categories: [:name, dishes: [:name, :price, :ingredients]], new_dishes: [:name, :price, :ingredients], new_category: [:name])
  end
end
