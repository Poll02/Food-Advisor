class RicercaController < ApplicationController
    def index
        @restaurants = Ristoratori.all
    end

    def search
        query = params[:query]
        @restaurants = if query.present?
                        Ristoratori.where('restaurant_name LIKE ?', "%#{query}%")
                       else
                        Ristoratori.all
                       end
    
        render json: @restaurants.map { |restaurant| 
          {
            id: restaurant.id,
            restaurant_name: restaurant.restaurant_name,
            foto_url: restaurant.foto.attached? ? url_for(restaurant.foto) : ActionController::Base.helpers.asset_path('background.jpg')
          }
        }
      end
end
