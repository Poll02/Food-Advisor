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

        # Aggiorna i piatti esistenti e elimina quelli contrassegnati per l'eliminazione
        category_params[:dishes]&.each do |dish_id, dish_params|
          if dish_params[:delete] == '1'
            Dish.find(dish_id).destroy
          else
            dish = Dish.find(dish_id)
            dish.update!(dish_params.permit(:name, :price, :ingredients))
          end
        end

        # Aggiungi nuovi piatti solo se tutti i campi sono riempiti
        if params[:new_dishes][category_id].present? && params[:new_dishes][category_id][:name].present? &&
           params[:new_dishes][category_id][:price].present? && params[:new_dishes][category_id][:ingredients].present?
          Dish.create!(
            category_id: category_id,
            name: params[:new_dishes][category_id][:name],
            price: params[:new_dishes][category_id][:price],
            ingredients: params[:new_dishes][category_id][:ingredients]
          )
        end
      end

      # Aggiungi nuova categoria solo se è stata riempita
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
end
