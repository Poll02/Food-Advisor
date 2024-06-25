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
    # Aggiorna le categorie e i piatti esistenti
    params[:categories].each do |category_id, category_params|
      category = Category.find(category_id)
      category.update(name: category_params[:name])
      category_params[:dishes].each do |dish_id, dish_params|
        dish = category.dishes.find(dish_id)
        dish.update(dish_params)
      end
    end

    # Aggiungi nuovi piatti
    if params[:new_dishes]
      params[:new_dishes].each do |category_id, new_dish_params|
        category = Category.find(category_id)
        category.dishes.create(new_dish_params)
      end
    end

    # Aggiungi nuove categorie
    if params[:new_category]
      new_category = Category.create(params[:new_category].permit(:name))
      if params[:new_dishes][new_category.id.to_s]
        new_category.dishes.create(params[:new_dishes][new_category.id.to_s])
      end
    end

    redirect_to menus_path
  end
end
